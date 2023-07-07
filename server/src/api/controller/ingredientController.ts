import express = require("express");
import AbstractController from "./abstractController";

/**
 * @description This class contains the controller for the ingredient router.
 * @class IngredientRouter
 * @extends abstractRouter
 * @exports IngredientRouter
 * @version 1.0.0
 * @requires IngredientController
 * @requires express
 * @requires AbstractController
 */
export default class IngredientController extends AbstractController {

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void
   */ 
  constructor() {
    super();
  }

  /**
   * @description This function gets all ingredients.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async ingredientsGet(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.ingredient.findMany().then((result) => {
      res.status(200).json(result);
    }
    ).catch((error) => {
      req.statusCode = 409;
      next(error);
    });
  }
}
