import express = require("express");
import CheckAuthorization from "../middleware/checkAuthorization";
import AbstractController from "../controller/abstractController";
import SchemaValidator from "../middleware/schemaValidator";

abstract class abstractRouter {
  protected router: express.Router;
  protected checkAuth: any;
  protected Controller: AbstractController;
  protected checkAuthorization: CheckAuthorization;
  protected schemaValidator: SchemaValidator;

  constructor() {
    this.router = express.Router();
    this.checkAuthorization = new CheckAuthorization();
    this.checkAuth = this.checkAuthorization.checkAuthorization.bind(
      this.checkAuthorization
    );
    this.schemaValidator = new SchemaValidator();
  }

  protected abstract setupRoutes(): void;

  public getRouter(): express.Router {
    return this.router;
  }
}

export default abstractRouter;
