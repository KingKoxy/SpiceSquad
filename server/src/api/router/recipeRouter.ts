import RecipeController from '../controller/recipeController'
import abstractRouter from './abstractRouter'
import {
  recipeCreateSchema,
  recipeDeleteSchema,
  recipeGetAllSchema,
  recipeReportSchema,
  recipeSetFavorite,
  recipeUpdateSchema,
} from '../../schemas/recipeSchema'

/**
 * @description This class contains the router for the recipe router.
 * @class RecipeRouter
 * @extends abstractRouter
 * @exports RecipeRouter
 * @version 1.0.0
 * @requires RecipeController
 */
export default class RecipeRouter extends abstractRouter {
  /**
   * @description This property contains the controller for the recipe router.
   * @memberof RecipeRouter
   * @protected
   * @type {RecipeController}
   */
  protected Controller: RecipeController

  /**
   * @constructor
   * @description This constructor initializes the recipe router.
   * @memberof RecipeRouter
   * @instance
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
    this.Controller = new RecipeController()
    this.setupRoutes()
  }

  /**
   * @function setupRoutes
   * @description This function sets up the routes for the admin user.
   * @memberof RecipeRouter
   * @instance
   * @returns {void}
   * @protected
   */
  protected setupRoutes(): void {
    this.router.post(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeCreateSchema),
      this.Controller.recipePost.bind(this.Controller)
    )
    this.router.get(
      '/:userId',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeGetAllSchema),
      this.Controller.recipesGetAllForUser.bind(this.Controller)
    )
    this.router.delete(
      '/:productId',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeDeleteSchema),
      this.Controller.recipeDelete.bind(this.Controller)
    )
    this.router.patch(
      '/:productId',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeUpdateSchema),
      this.Controller.recipePatch.bind(this.Controller)
    )
    this.router.patch(
      '/setFavorite/:productId',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeSetFavorite),
      this.Controller.recipeSetFavorite.bind(this.Controller)
    )
    this.router.post(
      '/report/:productId',
      this.checkAuth,
      this.schemaValidator.checkSchema(recipeReportSchema),
      this.Controller.recipeReport.bind(this.Controller)
    )
  }
}
