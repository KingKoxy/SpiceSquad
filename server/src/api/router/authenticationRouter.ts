import AuthenticationController from '../controller/authenticationController'
import AbstractRouter from './abstractRouter'
import {
  registerSchema,
  loginSchema,
  resetPasswordSchema,
  refreshTokenSchema,
  logoutSchema,
} from '../../schemas/authentificationSchema'

/**
 * @description This class contains the routes for the authentication.
 * @class AuthenticationRouter
 * @extends AbstractRouter
 * @exports AuthenticationRouter
 * @version 1.0.0
 * @requires AuthenticationController
 */
export default class AuthenticationRouter extends AbstractRouter {
  protected Controller: AuthenticationController

  /**
   * @constructor
   * @description This constructor initializes the admin user router.
   * @memberof AuthenticationRouter
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
   * @memberof AuthenticationRouter
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
