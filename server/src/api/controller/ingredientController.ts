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
   * @param req Express request handler
   * @param res Express response handler
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
   * @param req Express request handler
   * @param res Express response handler
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
        result.forEach((icon) => {
          icon.id = process.env.ICON_URL + icon.id
      })
      res.status(200).json(result)
   })
  }
  

  public async ingredientIconGetById(
    req: express.Request< { id }, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.ingredientIcon
      .findUnique({
        where: {
          id: req.params.id,
        },
      })
      .then((result) => {
        res.status(200).json(result)
      }
      )
      .catch((error) => {
        next(error)
      }
      )
    }
  


}
