import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getFilterSchemaFor,
  getModelSchemaRef,
  getWhereSchemaFor,
  patch,
  put,
  del,
  requestBody,
  HttpErrors,
} from '@loopback/rest';
import { Alert } from '../models';
import { AlertRepository } from '../repositories';
import { authenticate } from '@loopback/authentication';
import { UserProfile, SecurityBindings } from '@loopback/security';
import { secured, SecuredType } from '../auth';
import { inject } from '@loopback/core';
import { OPERATION_SECURITY_SPEC } from '../security-spec';

export class AlertController {
  constructor(
    @repository(AlertRepository)
    public alertRepository: AlertRepository,
    @inject(SecurityBindings.USER) private user: UserProfile
  ) { }

  @post('/alerts', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '200': {
        description: 'Alert model instance',
        content: { 'application/json': { schema: getModelSchemaRef(Alert) } },
      },
    },
  })
  @secured(SecuredType.HAS_ROLES, ['Customer'])
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Alert, {
            title: 'NewAlert',
            exclude: ['id'],
          }),
        },
      },
    })
    alert: Omit<Alert, 'id'>,
  ): Promise<Alert> {
    if (!this.user || this.user.email != alert.customerEmail) {
      throw new HttpErrors.Unauthorized('Customers are only allowed to create alerts for themselves');
    }
    return this.alertRepository.create(alert);
  }

  // @get('/alerts/count', {
  //   responses: {
  //     '200': {
  //       description: 'Alert model count',
  //       content: {'application/json': {schema: CountSchema}},
  //     },
  //   },
  // })
  // async count(
  //   @param.query.object('where', getWhereSchemaFor(Alert)) where?: Where<Alert>,
  // ): Promise<Count> {
  //   return this.alertRepository.count(where);
  // }

  // @get('/alerts', {
  //   responses: {
  //     '200': {
  //       description: 'Array of Alert model instances',
  //       content: {
  //         'application/json': {
  //           schema: {
  //             type: 'array',
  //             items: getModelSchemaRef(Alert, {includeRelations: true}),
  //           },
  //         },
  //       },
  //     },
  //   },
  // })
  // async find(
  //   @param.query.object('filter', getFilterSchemaFor(Alert)) filter?: Filter<Alert>,
  // ): Promise<Alert[]> {
  //   return this.alertRepository.find(filter);
  // }

  // @patch('/alerts', {
  //   responses: {
  //     '200': {
  //       description: 'Alert PATCH success count',
  //       content: {'application/json': {schema: CountSchema}},
  //     },
  //   },
  // })
  // async updateAll(
  //   @requestBody({
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Alert, {partial: true}),
  //       },
  //     },
  //   })
  //   alert: Alert,
  //   @param.query.object('where', getWhereSchemaFor(Alert)) where?: Where<Alert>,
  // ): Promise<Count> {
  //   return this.alertRepository.updateAll(alert, where);
  // }

  // @get('/alerts/{id}', {
  //   responses: {
  //     '200': {
  //       description: 'Alert model instance',
  //       content: {
  //         'application/json': {
  //           schema: getModelSchemaRef(Alert, {includeRelations: true}),
  //         },
  //       },
  //     },
  //   },
  // })
  // async findById(
  //   @param.path.number('id') id: number,
  //   @param.query.object('filter', getFilterSchemaFor(Alert)) filter?: Filter<Alert>
  // ): Promise<Alert> {
  //   return this.alertRepository.findById(id, filter);
  // }

  // @patch('/alerts/{id}', {
  //   responses: {
  //     '204': {
  //       description: 'Alert PATCH success',
  //     },
  //   },
  // })
  // async updateById(
  //   @param.path.number('id') id: number,
  //   @requestBody({
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Alert, {partial: true}),
  //       },
  //     },
  //   })
  //   alert: Alert,
  // ): Promise<void> {
  //   await this.alertRepository.updateById(id, alert);
  // }

  // @put('/alerts/{id}', {
  //   responses: {
  //     '204': {
  //       description: 'Alert PUT success',
  //     },
  //   },
  // })
  // async replaceById(
  //   @param.path.number('id') id: number,
  //   @requestBody() alert: Alert,
  // ): Promise<void> {
  //   await this.alertRepository.replaceById(id, alert);
  // }

  // @del('/alerts/{id}', {
  //   responses: {
  //     '204': {
  //       description: 'Alert DELETE success',
  //     },
  //   },
  // })
  // async deleteById(@param.path.number('id') id: number): Promise<void> {
  //   await this.alertRepository.deleteById(id);
  // }
}
