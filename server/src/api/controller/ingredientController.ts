import express = require("express");
import AbstractController from "./abstractController";

class IngredientController extends AbstractController {
  constructor() {
    super();
  }

  public async ingredientsGet(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    res.status(200).json({
      message: "Handling GET requests to /ingredients",
    });
  }
}

export default IngredientController;
