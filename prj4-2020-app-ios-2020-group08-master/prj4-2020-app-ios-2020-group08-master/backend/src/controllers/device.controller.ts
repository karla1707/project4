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
import { Device } from '../models';
import { DeviceRepository } from '../repositories';
import { UserProfile, SecurityBindings } from '@loopback/security';
import { secured, SecuredType } from '../auth';
import { inject } from '@loopback/core';
import { OPERATION_SECURITY_SPEC } from '../security-spec';

export class DeviceController {
  constructor(
    @repository(DeviceRepository)
    public deviceRepository: DeviceRepository,
    @inject(SecurityBindings.USER) private user: UserProfile
  ) { }

  @put('/devices/{id}', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '204': {
        description: 'Device PUT success',
      },
    },
  })
  @secured(SecuredType.HAS_ANY_ROLE, ["Customer"])
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() device: Device,
  ): Promise<void> {
    if (this.user.email != device.customerEmail) {
      throw new HttpErrors.Unauthorized('Customers are only allowed to register devices for themselves');
    }
    let exists = await this.deviceRepository.exists(id);
    if (exists) {
      await this.deviceRepository.updateById(id, device);
    } else {
      await this.deviceRepository.create(device);
    }
  }

  // @post('/devices', {
  //   security: OPERATION_SECURITY_SPEC,
  //   responses: {
  //     '200': {
  //       description: 'Device model instance',
  //       content: { 'application/json': { schema: getModelSchemaRef(Device) } },
  //     },
  //   },
  // })
  // @secured(SecuredType.IS_AUTHENTICATED)
  // async create(
  //   @requestBody({
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Device, {
  //           title: 'NewDevice',

  //         }),
  //       },
  //     },
  //   })
  //   device: Device,
  // ): Promise<Device> {
  //   if (this.user.email != device.customerEmail) {
  //     throw new HttpErrors.Unauthorized('Customers are only allowed to register devices for themselves');
  //   }
  //   return this.deviceRepository.create(device);
  // }

  // @get('/devices/count', {
  //   responses: {
  //     '200': {
  //       description: 'Device model count',
  //       content: {'application/json': {schema: CountSchema}},
  //     },
  //   },
  // })
  // async count(
  //   @param.query.object('where', getWhereSchemaFor(Device)) where?: Where<Device>,
  // ): Promise<Count> {
  //   return this.deviceRepository.count(where);
  // }

  // @get('/devices', {
  //   responses: {
  //     '200': {
  //       description: 'Array of Device model instances',
  //       content: {
  //         'application/json': {
  //           schema: {
  //             type: 'array',
  //             items: getModelSchemaRef(Device, {includeRelations: true}),
  //           },
  //         },
  //       },
  //     },
  //   },
  // })
  // async find(
  //   @param.query.object('filter', getFilterSchemaFor(Device)) filter?: Filter<Device>,
  // ): Promise<Device[]> {
  //   return this.deviceRepository.find(filter);
  // }

  // @patch('/devices', {
  //   responses: {
  //     '200': {
  //       description: 'Device PATCH success count',
  //       content: {'application/json': {schema: CountSchema}},
  //     },
  //   },
  // })
  // async updateAll(
  //   @requestBody({
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Device, {partial: true}),
  //       },
  //     },
  //   })
  //   device: Device,
  //   @param.query.object('where', getWhereSchemaFor(Device)) where?: Where<Device>,
  // ): Promise<Count> {
  //   return this.deviceRepository.updateAll(device, where);
  // }

  // @get('/devices/{id}', {
  //   responses: {
  //     '200': {
  //       description: 'Device model instance',
  //       content: {
  //         'application/json': {
  //           schema: getModelSchemaRef(Device, {includeRelations: true}),
  //         },
  //       },
  //     },
  //   },
  // })
  // async findById(
  //   @param.path.string('id') id: string,
  //   @param.query.object('filter', getFilterSchemaFor(Device)) filter?: Filter<Device>
  // ): Promise<Device> {
  //   return this.deviceRepository.findById(id, filter);
  // }

  // @patch('/devices/{id}', {
  //   responses: {
  //     '204': {
  //       description: 'Device PATCH success',
  //     },
  //   },
  // })
  // async updateById(
  //   @param.path.string('id') id: string,
  //   @requestBody({
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Device, {partial: true}),
  //       },
  //     },
  //   })
  //   device: Device,
  // ): Promise<void> {
  //   await this.deviceRepository.updateById(id, device);
  // }



  // @del('/devices/{id}', {
  //   responses: {
  //     '204': {
  //       description: 'Device DELETE success',
  //     },
  //   },
  // })
  // async deleteById(@param.path.string('id') id: string): Promise<void> {
  //   await this.deviceRepository.deleteById(id);
  // }
}
