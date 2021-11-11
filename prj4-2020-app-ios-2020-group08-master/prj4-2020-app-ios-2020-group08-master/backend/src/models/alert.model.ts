import { Entity, model, property } from '@loopback/repository';

@model()
export class Alert extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true,
  })
  customerEmail: string;

  @property({
    type: 'number',
    required: true,
  })
  productId: number;

  @property({
    type: 'number',
    required: true,
    jsonSchema: {
      minimum: 0,
      errorMessage:
        'The price set in an alert must be positive',
    },
  })
  maxPrice: number;

  constructor(data?: Partial<Alert>) {
    super(data);
  }
}

export interface AlertRelations {
  // describe navigational properties here
}

export type AlertWithRelations = Alert & AlertRelations;
