import GroupController from '../controller/groupController'
import AbstractRouter from './abstractRouter'
import {
  GroupCreateSchema,
  GroupDeleteSchema,
  GroupGetAllSchema,
  GroupJoinSchema,
  GroupLeaveSchema,
  GroupUpdateSchema,
} from '../../schemas/groupSchema'

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

  /**
   * @constructor
   * @description This constructor initializes the admin user router.
   * @memberof GroupRouter
   * @instance
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
    this.Controller = new GroupController()
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the admin user.
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
      this.schemaValidator.checkSchema(GroupDeleteSchema),
      this.Controller.groupDelete.bind(this.Controller)
    )
    this.router.patch(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupUpdateSchema),
      this.Controller.groupPatch.bind(this.Controller)
    )
    this.router.patch(
      '/join',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupJoinSchema),
      this.Controller.groupJoin.bind(this.Controller)
    )
    this.router.patch(
      '/leave',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupLeaveSchema),
      this.Controller.groupLeave.bind(this.Controller)
    )
    this.router.get(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(GroupGetAllSchema),
      this.Controller.groupGetAllForUser.bind(this.Controller)
    )
  }
}
