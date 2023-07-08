import express = require('express')
import CheckAuthorization from '../middleware/checkAuthorization'
import AbstractController from '../controller/abstractController'
import SchemaValidator from '../middleware/schemaValidator'

/**
 * @class abstractRouter
 * @description This class is the abstract class for all routers.
 * @exports abstractRouter
 * @abstract
 * @version 1.0.0
 * @abstract
 * @requires express
 * @requires CheckAuthorization
 * @requires AbstractController
 * @requires SchemaValidator
 */
export default abstract class abstractRouter {
    /**
     * @description This property contains the router for the recipe router.
     * @memberof abstractRouter
     * @protected
     * @type {express.Router}
     */
    protected router: express.Router

    /**
     * @description This property contains the checkAuth function.
     * @memberof abstractRouter
     * @protected
     * @type {*}
     */
    protected checkAuth: any

    /**
     * @description This property contains the controller for the recipe router.
     * @memberof abstractRouter
     * @protected
     * @type {AbstractController}
     */
    protected Controller: AbstractController

    /**
     * @description This property contains the checkAuthorization function.
     * @memberof abstractRouter
     * @protected
     * @type {CheckAuthorization}
     */
    protected checkAuthorization: CheckAuthorization

    /**
     * @description This property contains the schemaValidator.
     * @memberof abstractRouter
     * @protected
     * @type {SchemaValidator}
     */
    protected schemaValidator: SchemaValidator

    /**
     * @constructor
     * @description This constructor initializes the abstract router.
     * @memberof abstractRouter
     * @instance
     * @returns {void}
     */
    constructor() {
        this.router = express.Router()
        this.checkAuthorization = new CheckAuthorization()
        this.checkAuth = this.checkAuthorization.checkAuthorization.bind(this.checkAuthorization)
        this.schemaValidator = new SchemaValidator()
    }

    /**
     * @function setupRoutes
     * @description This function sets up the routes for the admin user.
     * @memberof abstractRouter
     * @returns {void}
     * @abstract
     * @protected
     */
    protected abstract setupRoutes(): void

    /**
     * @function getRouter
     * @description This function returns the router.
     * @memberof abstractRouter
     * @returns {express.Router}
     * @public
     */
    public getRouter(): express.Router {
        return this.router
    }
}
