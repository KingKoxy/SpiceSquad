import AdminUserController from '../controller/adminUserController'
import CheckAdminStatus from '../middleware/checkAdminStatus'
import AbstractRouter from './abstractRouter'
import {} from '../../schemas/adminUserSchema'
import checkGroupMemberState from '../middleware/checkGroupMemberState'
import { setCensored } from '../../schemas/adminUserSchema'

/**
 * @class AdminUserRouter
 * @description This class is used to manage the routes for the admin user.
 * @exports AdminUserRouter
 * @version 1.0.0
 * @extends AbstractRouter
 * @requires AdminUserController
 */
export default class AdminUserRouter extends AbstractRouter {
  /**
   * @description This property contains the controller for the admin user router.
   * @memberof AdminUserRouter
   * @protected
   * @type {AdminUserController}
   */
  protected Controller: AdminUserController

  /**
   * @description This property contains the checkAdmin function.
   * @memberof AdminUserRouter
   * @protected
   * @type {*}
   */
  protected checkAdmin: any

  /**
   * @description This property contains the checkAdminStatus function.
   * @memberof AdminUserRouter
   * @protected
   * @type {CheckAdminStatus}
   */
  protected checkAdminStatus: CheckAdminStatus

  protected checkGroupMemberState: checkGroupMemberState
  protected checkMemberStateTarget: any

  /**
   * @constructor
   * @description This constructor initializes the admin user router.
   * @memberof AdminUserRouter
   * @returns {void}
   */
  constructor() {
    super()
    this.checkAdminStatus = new CheckAdminStatus()
    this.checkAdmin = this.checkAdminStatus.checkAdminStatus.bind(this.checkAdminStatus)
    this.Controller = new AdminUserController()
    this.checkGroupMemberState = new checkGroupMemberState()
    this.checkMemberStateTarget = this.checkGroupMemberState.checkMemberStateTarget.bind(this.checkGroupMemberState)
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the router.
   * @memberof AdminUserRouter
   * @returns {void}
   * @protected
   */
  protected setupRoutes(): void {
    this.router.patch(
      '/makeAdmin/:groupId/:targetId',
      this.checkAuth,
      this.checkAdmin,
      this.checkMemberStateTarget,
      this.Controller.makeAdmin.bind(this.Controller)
    )

    this.router.patch(
      '/removeAdmin/:groupId/:targetId',
      this.checkAuth,
      this.checkAdmin,
      this.checkMemberStateTarget,
      this.Controller.removeAdmin.bind(this.Controller)
    )

    this.router.patch(
      '/kickUser/:groupId/:targetId',
      this.checkAuth,
      this.checkAdmin,
      this.checkMemberStateTarget,
      this.Controller.kickUser.bind(this.Controller)
    )
    this.router.patch(
      '/banUser/:groupId/:targetId',
      this.checkAuth,
      this.checkAdmin,
      this.checkMemberStateTarget,
      this.Controller.banUser.bind(this.Controller)
    )
    this.router.patch(
      '/setCensored/:groupId/:recipeId',
      this.checkAuth,
      this.checkAdmin,
      this.schemaValidator.checkSchema(setCensored),
      this.Controller.setCensored.bind(this.Controller),
    )
  }
}
