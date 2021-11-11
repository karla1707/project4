import {DefaultCrudRepository} from '@loopback/repository';
import {Seller, SellerRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class SellerRepository extends DefaultCrudRepository<
  Seller,
  typeof Seller.prototype.id,
  SellerRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(Seller, dataSource);
  }
}
