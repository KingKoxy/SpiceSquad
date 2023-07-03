import AdminUserController from "../controller/adminUserController";
import abstractRouter from "./abstractRouter";

class AdminUserRouter extends abstractRouter {
  protected Controller: AdminUserController;

  constructor() {
    super();
    this.Controller = new AdminUserController();
    this.setupRoutes();
  }

  protected setupRoutes(): void {
    this.router.patch(
      "/makeAdmin",
      this.checkAuth,
      this.Controller.makeAdmin.bind(this.Controller)
    );
    this.router.patch(
      "/removeAdmin",
      this.checkAuth,
      this.Controller.removeAdmin.bind(this.Controller)
    );
    this.router.patch(
      "/kickUser",
      this.checkAuth,
      this.Controller.kickUser.bind(this.Controller)
    );
    this.router.patch(
      "/banUser",
      this.checkAuth,
      this.Controller.banUser.bind(this.Controller)
    );
    this.router.patch(
      "/setCensored",
      this.checkAuth,
      this.Controller.setCensored.bind(this.Controller)
    );
  }
}

export default AdminUserRouter;
