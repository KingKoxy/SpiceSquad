import AdminUserController from "../controller/adminUserController";
import CheckAdminStatus from "../middleware/checkAdminStatus";
import abstractRouter from "./abstractRouter";

class AdminUserRouter extends abstractRouter {
  protected Controller: AdminUserController;
  protected checkAdmin: any;
  protected checkAdminStatus: CheckAdminStatus;

  constructor() {
    super();
    this.checkAdminStatus = new CheckAdminStatus();
    this.checkAdmin = this.checkAdminStatus.checkAdminStatus.bind(
      this.checkAdminStatus
    );
    this.Controller = new AdminUserController();
    this.setupRoutes();
  }

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

export default AdminUserRouter;
