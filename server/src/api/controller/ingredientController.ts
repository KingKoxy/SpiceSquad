import express = require('express')
import AbstractController from './abstractController'

export default class IngredientController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
  }

  /**
   * @description This function gets all ingredient names.
   * @param req Express Request<never,never,never>
   * @param res Express responsecontaining all ingredient names as array
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async ingredientNameGet(
    req: express.Request< never, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.ingredientName
      .findMany()
      .then((result) => {
        res.status(200).json(result)
      })
      .catch((error) => {
        next(error)
      })
  }

  /**
   * @description This function gets all ingredient icons.
   * @param req Express Request<never,never,never>
   * @param res Express response containing all ingredient icons as array
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async ingredientIconGet(
    req: express.Request< never, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.ingredientIcon
      .findMany()
      .then((result) => {
        res.status(200).json(result)
      })
      .catch((error) => {
        next(error)
      })
  }
}
