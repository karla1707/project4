import { Entity, model, property } from '@loopback/repository';

@model()
export class Role extends Entity {

  @property({
    type: 'string',
    id : true,
    required: true,
  })
  description: string;

  constructor(data?: Partial<Role>) {
    super(data);
  }
}

export interface RoleRelations {
  // describe navigational properties here
}
