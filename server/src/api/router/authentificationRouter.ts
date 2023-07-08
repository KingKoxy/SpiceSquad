import AuthenticationController from '../controller/authenticationController'
import abstractRouter from './abstractRouter'
import {
    registerSchema,
    loginSchema,
    resetPasswordSchema,
    getUserByTokenSchema,
    refreshTokenSchema,
    logoutSchema,
} from '../../schemas/authentificationSchema'

/**
 * @description This class contains the routes for the authentification.
 * @class AuthentificationRouter
 * @extends abstractRouter
 * @exports AuthentificationRouter
 * @version 1.0.0
 * @requires AuthenticationController
 */
export default class AuthentificationRouter extends abstractRouter {
    protected Controller: AuthenticationController

    /**
     * @constructor
     * @description This constructor initializes the admin user router.
     * @memberof AuthentificationRouter
     * @returns {void}
     * @protected
     */
    constructor() {
        super()
        this.Controller = new AuthenticationController()
        this.setupRoutes()
    }

    /**
     * @function setupRoutes
     * @description This function sets up the routes for the admin user.
     * @memberof AuthentificationRouter
     * @instance
     * @returns {void}
     * @protected
     */
    protected setupRoutes(): void {
        this.router.post(
            '/register',
            this.schemaValidator.checkSchema(registerSchema),
            this.Controller.userRegister.bind(this.Controller)
        )
        this.router.post(
            '/login',
            this.schemaValidator.checkSchema(loginSchema),
            this.Controller.userLogin.bind(this.Controller)
        )
        this.router.post(
            '/resetPassword',
            this.schemaValidator.checkSchema(resetPasswordSchema),
            this.Controller.userResetPassword.bind(this.Controller)
        )
        this.router.get(
            '/refreshToken',
            this.schemaValidator.checkSchema(refreshTokenSchema),
            this.Controller.userRefreshToken.bind(this.Controller)
        )
        this.router.get(
            '/logout',
            this.schemaValidator.checkSchema(logoutSchema),
            this.Controller.userLogout.bind(this.Controller)
        )
    }
}
