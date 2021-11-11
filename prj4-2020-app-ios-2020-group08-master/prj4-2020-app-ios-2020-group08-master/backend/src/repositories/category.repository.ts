import {DefaultCrudRepository} from '@loopback/repository';
import {Category, CategoryRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class CategoryRepository extends DefaultCrudRepository<
  Category,
  typeof Category.prototype.name,
  CategoryRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(Category, dataSource);
  }
}
