import RecipeController from '../controller/recipeController';
import abstractRouter from './abstractRouter';

class RecipeRouter extends abstractRouter {

    protected Controller: RecipeController;

    constructor() {
        super();
        this.Controller = new RecipeController();
        this.setupRoutes();
    }

    protected setupRoutes(): void {
        this.router.post('/', this.checkAuth, this.Controller.recipePost.bind(this.Controller));
        this.router.get('/', this.checkAuth, this.Controller.recipesGetAllForUser.bind(this.Controller));
        this.router.delete('/:productId', this.checkAuth, this.Controller.recipeDelete.bind(this.Controller));
        this.router.patch('/:productId', this.checkAuth, this.Controller.recipePatch.bind(this.Controller));
        this.router.patch('/setFavorite', this.checkAuth, this.Controller.recipeSetFavorite.bind(this.Controller));
        this.router.get('/report/:productId', this.checkAuth, this.Controller.recipeReport.bind(this.Controller));
    }

}

export default RecipeRouter