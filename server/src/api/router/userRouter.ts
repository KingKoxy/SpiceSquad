import UserController from '../controller/userController'
import abstractRouter from './abstractRouter'
import { userDeleteSchema, userGetSchema, userPatchSchema } from '../../schemas/userSchema'

/**
 * @description This class contains the router for the user router.
 * @class UserRouter
 * @extends abstractRouter
 * @exports UserRouter
 * @version 1.0.0
 * @requires UserController
 */
export default class UserRouter extends abstractRouter {
    /**
     * @description This property contains the controller for the user router.
     * @memberof UserRouter
     * @protected
     * @type {UserController}
     */
    protected Controller: UserController

    /**
     * @constructor
     * @description This constructor initializes the admin user router.
     * @memberof UserRouter
     * @instance
     * @returns {void}
     * @protected
     */
    constructor() {
        super()
        this.Controller = new UserController()
        this.setupRoutes()
    }

    /**
     * @function setupRoutes
     * @description This function sets up the routes for the admin user.
     * @memberof UserRouter
     * @instance
     * @returns {void}
     * @protected
     */
    protected setupRoutes(): void {
        this.router.delete(
            '/',
            this.checkAuth,
            this.schemaValidator.checkSchema(userDeleteSchema),
            this.Controller.userDelete.bind(this.Controller)
        )
        this.router.patch(
            '/',
            this.checkAuth,
            this.schemaValidator.checkSchema(userPatchSchema),
            this.Controller.userPatch.bind(this.Controller)
        )
        this.router.get(
            '/',
            this.schemaValidator.checkSchema(userGetSchema),
            this.Controller.userGet.bind(this.Controller)
        )
    }
}
