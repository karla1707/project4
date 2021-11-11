import {DefaultCrudRepository} from '@loopback/repository';
import {Alert, AlertRelations} from '../models';
import {ElephantSqlDataSource} from '../datasources';
import {inject} from '@loopback/core';

export class AlertRepository extends DefaultCrudRepository<
  Alert,
  typeof Alert.prototype.id,
  AlertRelations
> {
  constructor(
    @inject('datasources.ElephantSQL') dataSource: ElephantSqlDataSource,
  ) {
    super(Alert, dataSource);
  }
}
