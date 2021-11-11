import { post, requestBody, HttpErrors, param, put, getModelSchemaRef } from '@loopback/rest';
import { User, Credentials } from '../models';
import { UserRepository, UserRoleRepository } from '../repositories';
import { repository } from '@loopback/repository';
import { JWT_SECRET } from '../auth';
import { promisify } from 'util';

const { sign } = require('jsonwebtoken');
const signAsync = promisify(sign);

export class UserController {
  constructor(
    @repository(UserRepository) private userRepository: UserRepository,
    @repository(UserRoleRepository) private userRoleRepository: UserRoleRepository,
  ) { }

  // @post('/users')
  // async createUser(@requestBody() user: User): Promise<User> {
  //   return await this.userRepository.create(user);
  // }

  @put('/users/{id}', {
    responses: {
      '204': {
        description: 'User PUT success',
      },
    },
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() user: User,
  ): Promise<void> {
    // hash pw
    const bcrypt = require('bcrypt');
    user.password = bcrypt.hashSync(user.password, 10);
    console.log(user);
    await this.userRepository.replaceById(id, user);
  }

  @post('/users/login')
  async login(@requestBody(
    {
      content: {
        'application/json': {
          schema: getModelSchemaRef(Credentials, {
            title: 'Credential',

          }),
        },
      },
    }
  ) credentials: Credentials) {
    if (!credentials.email || !credentials.password) throw new HttpErrors.BadRequest('Missing email or Password');
    const user = await this.userRepository.findOne({ where: { email: credentials.email } });
    if (!user) throw new HttpErrors.Unauthorized('Invalid credentials');

    const bcrypt = require('bcrypt');
    const isPasswordMatched = bcrypt.compareSync(credentials.password, user.password);
    if (!isPasswordMatched) throw new HttpErrors.Unauthorized('Invalid credentials');

    const tokenObject = { email: credentials.email };
    const token = await signAsync(tokenObject, JWT_SECRET);
    const roles = await this.userRoleRepository.find({ where: { userId: user.email } });
    const { email } = user;

    return {
      token,
      email,
      roles: roles.map(r => r.roleId),
    };
  }
}
