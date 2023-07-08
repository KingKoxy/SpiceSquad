import { PrismaClient } from '@prisma/client'

/**
 * @class AbstractMiddleware
 * @description This class is used to create an instance of the PrismaClient.
 * @exports AbstractMiddleware
 * @abstract
 * @version 1.0.0
 * @requires PrismaClient
 */
export default class AbstractMiddleware {
  protected prisma: PrismaClient

  /**
   * @constructor
   * @description This constructor initializes the abstract middleware.
   * @memberof abstractMiddleware
   * @returns {void}
   */
  constructor() {
    this.prisma = new PrismaClient()
  }
}
