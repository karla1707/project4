import {DefaultCrudRepository} from '@loopback/repository';
import {User, UserRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class UserRepository extends DefaultCrudRepository<
  User,
  typeof User.prototype.email,
  UserRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(User, dataSource);
  }
}
