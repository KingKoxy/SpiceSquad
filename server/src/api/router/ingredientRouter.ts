import IngredientController from '../controller/ingredientController'
import AbstractRouter from './abstractRouter'
import { ingredientIconGetSchema, ingredientNameGetSchema, ingredientIconGetByIdSchema } from '../../schemas/ingredientSchema'

/**
 * @description This class contains the router for the ingredient router.
 * @class IngredientRouter
 * @extends AbstractRouter
 * @exports IngredientRouter
 * @version 1.0.0
 * @requires IngredientController
 */
class IngredientRouter extends AbstractRouter {
  protected Controller: IngredientController

  /**
   * @constructor
   * @description This constructor initializes the ingredient router.
   * @memberof IngredientRouter
   * @instance
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
    this.Controller = new IngredientController()
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the router.
   * @memberof IngredientRouter
   * @instance
   * @returns {void}
   * @protected
   */
  protected setupRoutes(): void {
    this.router.get(
      '/names',
      this.schemaValidator.checkSchema(ingredientNameGetSchema),
      this.Controller.ingredientNameGet.bind(this.Controller)
    )
    this.router.get(
      '/icons',
      this.schemaValidator.checkSchema(ingredientIconGetSchema),
      this.Controller.ingredientIconGet.bind(this.Controller)
    )

    this.router.get(
      '/icons/:id',
      this.schemaValidator.checkSchema(ingredientIconGetByIdSchema),
      this.Controller.ingredientIconGetById.bind(this.Controller)
    )
  }
}

export default IngredientRouter
