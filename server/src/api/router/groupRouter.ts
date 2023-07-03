import GroupController from "../controller/groupController";
import abstractRouter from "./abstractRouter";

class GroupRouter extends abstractRouter {
  protected Controller: GroupController;

  constructor() {
    super();
    this.Controller = new GroupController();
    this.setupRoutes();
  }

  protected setupRoutes(): void {
    this.router.post(
      "/",
      this.checkAuth,
      this.Controller.groupPost.bind(this.Controller)
    );
    this.router.delete(
      "/",
      this.checkAuth,
      this.Controller.groupDelete.bind(this.Controller)
    );
    this.router.patch(
      "/",
      this.checkAuth,
      this.Controller.groupPatch.bind(this.Controller)
    );
    this.router.patch(
      "/join",
      this.checkAuth,
      this.Controller.groupJoin.bind(this.Controller)
    );
    this.router.patch(
      "/leave",
      this.checkAuth,
      this.Controller.groupLeave.bind(this.Controller)
    );
    this.router.get(
      "/",
      this.checkAuth,
      this.Controller.groupGetAllForUser.bind(this.Controller)
    );
  }
}

export default GroupRouter;
