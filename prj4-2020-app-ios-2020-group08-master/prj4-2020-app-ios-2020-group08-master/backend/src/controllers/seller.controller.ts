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
} from '@loopback/rest';
import {Seller} from '../models';
import {SellerRepository} from '../repositories';

export class SellerController {
  constructor(
    @repository(SellerRepository)
    public sellerRepository : SellerRepository,
  ) {}

  @post('/sellers', {
    responses: {
      '200': {
        description: 'Seller model instance',
        content: {'application/json': {schema: getModelSchemaRef(Seller)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Seller, {
            title: 'NewSeller',
            exclude: ['id'],
          }),
        },
      },
    })
    seller: Omit<Seller, 'id'>,
  ): Promise<Seller> {
    return this.sellerRepository.create(seller);
  }

  @get('/sellers/count', {
    responses: {
      '200': {
        description: 'Seller model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.query.object('where', getWhereSchemaFor(Seller)) where?: Where<Seller>,
  ): Promise<Count> {
    return this.sellerRepository.count(where);
  }

  @get('/sellers', {
    responses: {
      '200': {
        description: 'Array of Seller model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Seller, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.query.object('filter', getFilterSchemaFor(Seller)) filter?: Filter<Seller>,
  ): Promise<Seller[]> {
    return this.sellerRepository.find(filter);
  }

  @patch('/sellers', {
    responses: {
      '200': {
        description: 'Seller PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Seller, {partial: true}),
        },
      },
    })
    seller: Seller,
    @param.query.object('where', getWhereSchemaFor(Seller)) where?: Where<Seller>,
  ): Promise<Count> {
    return this.sellerRepository.updateAll(seller, where);
  }

  @get('/sellers/{id}', {
    responses: {
      '200': {
        description: 'Seller model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Seller, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.query.object('filter', getFilterSchemaFor(Seller)) filter?: Filter<Seller>
  ): Promise<Seller> {
    return this.sellerRepository.findById(id, filter);
  }

  @patch('/sellers/{id}', {
    responses: {
      '204': {
        description: 'Seller PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Seller, {partial: true}),
        },
      },
    })
    seller: Seller,
  ): Promise<void> {
    await this.sellerRepository.updateById(id, seller);
  }

  @put('/sellers/{id}', {
    responses: {
      '204': {
        description: 'Seller PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() seller: Seller,
  ): Promise<void> {
    await this.sellerRepository.replaceById(id, seller);
  }

  @del('/sellers/{id}', {
    responses: {
      '204': {
        description: 'Seller DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.sellerRepository.deleteById(id);
  }
}
