import AuthenticationController from '../controller/authenticationController'
import AbstractRouter from './abstractRouter'
import CheckAdminStatus from '../middleware/checkAdminStatus'
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
  protected CheckAdminStatus: CheckAdminStatus
  protected checkAdmin: any

  /**
   * @constructor
   * @description This constructor initializes the authentification router.
   * @memberof AuthenticationRouter
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
    this.Controller = new AuthenticationController()
    this.CheckAdminStatus = new CheckAdminStatus()
    this.checkAdmin = this.CheckAdminStatus.checkAdminStatus.bind(this.CheckAdminStatus)
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the router.
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
    this.router.post(
      '/refreshToken',
      this.schemaValidator.checkSchema(refreshTokenSchema),
      this.Controller.userRefreshToken.bind(this.Controller)
    )
    this.router.post(
      '/logout',
      this.checkAuth,
      this.schemaValidator.checkSchema(logoutSchema),
      this.Controller.userLogout.bind(this.Controller)
    )
  }
}
