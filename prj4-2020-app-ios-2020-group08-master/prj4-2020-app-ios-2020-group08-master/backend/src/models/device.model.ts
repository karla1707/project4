import { Entity, model, property } from '@loopback/repository';

@model()
export class Device extends Entity {
  @property({
    type: 'string',
    required: true,
  })
  token: string;

  @property({
    type: 'string',
    id: true,
    generated: false,
    required: true,
  })
  customerEmail: string;

  constructor(data?: Partial<Device>) {
    super(data);
  }
}

export interface DeviceRelations {
  // describe navigational properties here
}

export type DeviceWithRelations = Device & DeviceRelations;
