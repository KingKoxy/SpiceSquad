import IngredientController from "../controller/ingredientController";
import abstractRouter from "./abstractRouter";

class IngredientRouter extends abstractRouter {
  protected Controller: IngredientController;

  constructor() {
    super();
    this.Controller = new IngredientController();
    this.setupRoutes();
  }

  protected setupRoutes(): void {
    this.router.get(
      "/",
      this.checkAuth,
      this.Controller.ingredientsGet.bind(this.Controller)
    );
  }
}

export default IngredientRouter;
