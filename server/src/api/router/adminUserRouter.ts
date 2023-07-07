import AdminUserController from "../controller/adminUserController";
import CheckAdminStatus from "../middleware/checkAdminStatus";
import abstractRouter from "./abstractRouter";
import {} from "../../schemas/adminUserSchema";

/**
 * @class AdminUserRouter
 * @description This class is used to manage the routes for the admin user.
 * @exports AdminUserRouter
 * @version 1.0.0
 * @extends abstractRoute
 * @requires AdminUserController
 */
export default class AdminUserRouter extends abstractRouter {
  
  /**
   * @description This property contains the controller for the admin user router.
   * @memberof AdminUserRouter
   * @protected
   * @type {AdminUserController}
   */
  protected Controller: AdminUserController;

  /**
   * @description This property contains the checkAdmin function.
   * @memberof AdminUserRouter
   * @protected
   * @type {*}
   */ 
  protected checkAdmin: any;

  /**
   * @description This property contains the checkAdminStatus function.
   * @memberof AdminUserRouter
   * @protected
   * @type {CheckAdminStatus}
   */
  protected checkAdminStatus: CheckAdminStatus;

  /**
   * @constructor
   * @description This constructor initializes the admin user router.
   * @memberof AdminUserRouter
   * @returns {void}
   */
  constructor() {
    super();
    this.checkAdminStatus = new CheckAdminStatus();
    this.checkAdmin = this.checkAdminStatus.checkAdminStatus.bind(
      this.checkAdminStatus
    );
    this.Controller = new AdminUserController();
    this.setupRoutes();
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the admin user.
   * @memberof AdminUserRouter
   * @returns {void}
   * @protected
  */
  protected setupRoutes(): void {
    this.router.patch(
      "/makeAdmin",
      this.checkAuth,
      this.checkAdmin,
      this.Controller.makeAdmin.bind(this.Controller)
    );
    this.router.patch(
      "/removeAdmin",
      this.checkAuth,
      this.checkAdmin,
      this.Controller.removeAdmin.bind(this.Controller)
    );
    this.router.patch(
      "/kickUser",
      this.checkAuth,
      this.checkAdmin,
      this.Controller.kickUser.bind(this.Controller)
    );
    this.router.patch(
      "/banUser",
      this.checkAuth,
      this.checkAdmin,
      this.Controller.banUser.bind(this.Controller)
    );
    this.router.patch(
      "/setCensored",
      this.checkAuth,
      this.checkAdmin,
      this.Controller.setCensored.bind(this.Controller)
    );
  }
}
