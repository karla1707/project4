import {DefaultCrudRepository} from '@loopback/repository';
import {Customer, CustomerRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class CustomerRepository extends DefaultCrudRepository<
  Customer,
  typeof Customer.prototype.email,
  CustomerRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(Customer, dataSource);
  }
}
