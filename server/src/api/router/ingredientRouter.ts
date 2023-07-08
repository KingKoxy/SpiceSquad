import IngredientController from '../controller/ingredientController'
import abstractRouter from './abstractRouter'
import { ingredientGetSchema } from '../../schemas/ingredientSchema'

/**
 * @description This class contains the router for the ingredient router.
 * @class IngredientRouter
 * @extends abstractRouter
 * @exports IngredientRouter
 * @version 1.0.0
 * @requires IngredientController
 */
class IngredientRouter extends abstractRouter {
    protected Controller: IngredientController

    /**
     * @constructor
     * @description This constructor initializes the admin user router.
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
     * @description This function sets up the routes for the admin user.
     * @memberof IngredientRouter
     * @instance
     * @returns {void}
     * @protected
     */
    protected setupRoutes(): void {
        this.router.get(
            '/',
            this.checkAuth,
            this.schemaValidator.checkSchema(ingredientGetSchema),
            this.Controller.ingredientsGet.bind(this.Controller)
        )
    }
}

export default IngredientRouter
