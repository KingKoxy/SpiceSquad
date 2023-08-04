import GroupController from '../controller/groupController'
import AbstractRouter from './abstractRouter'
import {
  GroupCreateSchema,
  GroupDeleteSchema,
  GroupGetAllSchema,
  GroupJoinSchema,
  GroupLeaveSchema,
  GroupUpdateSchema,
  GroupGetIdSchema,
} from '../../schemas/groupSchema'
import CheckAdminStatus from '../middleware/checkAdminStatus'
import checkGroupMemberState from '../middleware/checkGroupMemberState'

/**
 * @description This class contains the router for the group router.
 * @class GroupRouter
 * @extends AbstractRouter
 * @exports GroupRouter
 * @version 1.0.0
 * @requires GroupController
 */
export default class GroupRouter extends AbstractRouter {
  protected Controller: GroupController
  protected CheckAdminStatus: CheckAdminStatus
  protected checkAdmin: any
  protected checkGroupMemberState: checkGroupMemberState
  protected checkMemberStateTarget: any

  /**
   * @constructor
   * @description This constructor initializes the group router.
   * @memberof GroupRouter
   * @instance
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
    this.Controller = new GroupController()
    this.CheckAdminStatus = new CheckAdminStatus()
    this.checkAdmin = this.CheckAdminStatus.checkAdminStatus.bind(this.CheckAdminStatus)
    this.checkGroupMemberState = new checkGroupMemberState()
    this.checkMemberStateTarget = this.checkGroupMemberState.checkMemberStateTarget.bind(this.checkGroupMemberState)
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the routerr.
   * @memberof GroupRouter
   * @instance
   * @returns {void}
   * @protected
   */
  protected setupRoutes(): void {
    this.router.post(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupCreateSchema),
      this.Controller.groupPost.bind(this.Controller)
    )
    this.router.delete(
      '/:groupId',
      this.checkAuth,
      this.checkAdmin,
      this.schemaValidator.checkSchema(GroupDeleteSchema),
      this.Controller.groupDelete.bind(this.Controller)
    )
    this.router.patch(
      '/join',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupJoinSchema),
      this.Controller.groupJoin.bind(this.Controller)
    )
    this.router.patch(
      '/:groupId',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupUpdateSchema),
      this.checkAdmin,
      this.Controller.groupPatch.bind(this.Controller)
    )

    this.router.patch(
      '/leave/:groupId',
      this.checkAuth,
      this.checkMemberStateTarget,
      this.schemaValidator.checkSchema(GroupLeaveSchema),
      this.Controller.groupLeave.bind(this.Controller)
    )
    this.router.get(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupGetAllSchema),
      this.Controller.groupGetAllForUser.bind(this.Controller)
    )

    this.router.get(
      '/:groupId',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupGetIdSchema),
      this.Controller.groupGetById.bind(this.Controller)
    )
  }
}
