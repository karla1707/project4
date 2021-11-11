import { Entity, model, property } from '@loopback/repository';

@model()
export class Seller extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true
  })
  email: string;

  @property({
    type: 'string',
    required: true,
  })
  name: string;

  @property({
    type: 'number',
    required: true,
  })
  locationId: number;

  @property({
    type: 'string',
    required: true,
  })
  logo: string;


  constructor(data?: Partial<Seller>) {
    super(data);
  }
}

export interface SellerRelations {
  // describe navigational properties here
}

export type SellerWithRelations = Seller & SellerRelations;
