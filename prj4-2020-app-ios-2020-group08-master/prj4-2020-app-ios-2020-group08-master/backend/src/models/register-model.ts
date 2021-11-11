import { Entity, model, property } from '@loopback/repository';

@model()
export class RegisterModel extends Entity {
  @property({
    type: 'string',
    required: true,
  })
  firstName: string;

  @property({
    type: 'string',
    required: true,
  })
  lastName: string;

  @property({
    type: 'string',
    id: true,
    generated: false,
    required: true,
  })
  email: string;

  @property({
    type: 'string',
    required: true,
  })
  password: string;

  @property({
    type: 'number',
  })
  locationId?: number;

  @property({
    type: 'string',
    required: true,
  })
  image: string;

  constructor(data?: Partial<RegisterModel>) {
    super(data);
  }
}

export interface RegisterModelRelations {
  // describe navigational properties here
}

export type CustomerWithRelations = RegisterModel & RegisterModelRelations;
