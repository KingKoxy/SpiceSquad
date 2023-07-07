import { PrismaClient } from "@prisma/client";

/**
 * @class abstractMiddleware
 * @description This class is used to create an instance of the PrismaClient.
 * @exports abstractMiddleware
 * @abstract
 * @version 1.0.0
 * @requires PrismaClient
 */
export default class abstractMiddleware {
    protected prisma: PrismaClient;

    /**
     * @constructor
     * @description This constructor initializes the abstract middleware.
     * @memberof abstractMiddleware
     * @returns {void}
     */
    constructor() {
        this.prisma = new PrismaClient();
    }

}