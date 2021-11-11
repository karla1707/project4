// Uncomment these imports to begin using these cool features!

import { post, getModelSchemaRef, requestBody } from "@loopback/rest";
import { Customer, User } from "../models";
import { RegisterModel } from "../models/register-model";
import { repository } from "@loopback/repository";
import { CustomerRepository, UserRepository, UserRoleRepository } from "../repositories";

// import {inject} from '@loopback/context';


export class RegisterController {

  constructor(
    @repository(CustomerRepository)
    public customerRepository: CustomerRepository,
    @repository(UserRepository)
    public userRepository: UserRepository,
    @repository(UserRoleRepository)
    public userRoleRepository: UserRoleRepository,
  ) { }

  @post('/register', {
    responses: {
      '200': {
        description: 'Customer model instance',
        content: { 'application/json': { schema: getModelSchemaRef(Customer) } },
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(RegisterModel, {
            title: 'NewRegister'
          }),
        },
      },
    })
    registermodel: RegisterModel,
  ): Promise<Customer> {

    console.log(registermodel);
    //create user model
    const bcrypt = require('bcrypt');
    console.log(registermodel.password);
    let hash = bcrypt.hashSync(registermodel.password, 10);
    let user = { email: registermodel.email, password: hash }

    let createdUser = await this.userRepository.create(user);

    //create userrole model
    let userrole = { userId: createdUser.email, roleId: "Customer" }
    this.userRoleRepository.create(userrole);

    //create customer model
    let customer = {
      email: registermodel.email
      , firstName: registermodel.firstName
      , lastName: registermodel.lastName
      , image: registermodel.image
      , locationId: registermodel.locationId
    }

    return this.customerRepository.create(customer);
  }
}
