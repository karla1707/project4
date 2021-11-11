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
import { Product } from '../models';
import { ProductRepository, SellerRepository } from '../repositories';
import { secured, SecuredType } from '../auth';
import { inject } from '@loopback/core';
import { UserProfile, SecurityBindings } from '@loopback/security';
import { OPERATION_SECURITY_SPEC } from '../security-spec';
import { checkServerIdentity } from 'tls';

export class ProductController {
  constructor(
    @repository(ProductRepository)
    public productRepository: ProductRepository,
    @repository(SellerRepository)
    public sellerRepository: SellerRepository
  ) { }

  @post('/products', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '200': {
        description: 'Product model instance',
        content: { 'application/json': { schema: getModelSchemaRef(Product) } },
      },
    },
  })
  @secured(SecuredType.HAS_ANY_ROLE, ['Seller'])
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Product, {
            title: 'NewProduct',
            exclude: ['id'],
          }),
        },
      },
    })
    product: Omit<Product, 'id'>,
    @inject(SecurityBindings.USER) user: UserProfile
  ): Promise<Product> {
    let sellers = await this.sellerRepository.find({ where: { email: user.email } })
    if (sellers[0].id != product.sellerId) {
      throw new HttpErrors.Unauthorized('Sellers are only allowed to create products for themeselves');
    }
    return this.productRepository.create(product);
  }

  @get('/products/count', {
    responses: {
      '200': {
        description: 'Product model count',
        content: { 'application/json': { schema: CountSchema } },
      },
    },
  })
  @secured(SecuredType.HAS_ANY_ROLE, ['Seller'])
  async count(
    @inject(SecurityBindings.USER) user: UserProfile,
    @param.query.object('where', getWhereSchemaFor(Product)) where?: Where<Product>,
  ): Promise<Count> {
    let seller = await this.sellerRepository.find({ where: { email: user.email } })
    if (seller[0].email != user.email) {
      throw new HttpErrors.Unauthorized('Sellers are only allowed to create products for themselves');
    }
    return this.productRepository.count(where);
  }

  @get('/products', {
    responses: {
      '200': {
        description: 'Array of Product model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Product, { includeRelations: true }),
            },
          },
        },
      },
    },
  })
  async find(
    @param.query.object('filter', getFilterSchemaFor(Product)) filter?: Filter<Product>,
  ): Promise<Product[]> {
    return this.productRepository.find(filter);
  }

  @get('/products/{id}', {
    responses: {
      '200': {
        description: 'Product model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Product, { includeRelations: true }),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.query.object('filter', getFilterSchemaFor(Product)) filter?: Filter<Product>
  ): Promise<Product> {
    return this.productRepository.findById(id, filter);
  }


  @patch('/products/{id}', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '204': {
        description: 'Product PATCH success',
      },
    },
  })
  @secured(SecuredType.HAS_ANY_ROLE, ['Seller'])
  async updateById(
    @param.path.number('id') id: number,
    @inject(SecurityBindings.USER) user: UserProfile,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Product, { partial: true }),
        },
      },
    })
    product: Product,
  ): Promise<void> {
    await this.checkSameSeller(id, user.email);
    await this.productRepository.updateById(id, product);
  }

  @del('/products/{id}', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '204': {
        description: 'Product DELETE success',
      },
    },
  })
  @secured(SecuredType.HAS_ANY_ROLE, ['Seller'])
  async deleteById(
    @param.path.number('id') id: number,
    @inject(SecurityBindings.USER) user: UserProfile
  ): Promise<void> {
    await this.checkSameSeller(id, user.email);
    await this.productRepository.deleteById(id);
  }

  async checkSameSeller(id: number, email: string | undefined) {
    // check if it is sellers product
    let sellers = await this.sellerRepository.find({ where: { email: email } })
    let product = await this.productRepository.findById(id);
    if (sellers[0].id != product.sellerId) {
      throw new HttpErrors.Unauthorized('Sellers are only allowed to change their own products');
    }
  }
}
