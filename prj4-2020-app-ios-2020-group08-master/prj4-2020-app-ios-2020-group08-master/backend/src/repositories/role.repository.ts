import {DefaultCrudRepository} from '@loopback/repository';
import {Role, RoleRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class RoleRepository extends DefaultCrudRepository<
  Role,
  typeof Role.prototype.description,
  RoleRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(Role, dataSource);
  }
}
