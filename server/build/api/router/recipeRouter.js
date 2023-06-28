"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const recipeController_1 = __importDefault(require("../controller/recipeController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class RecipeRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new recipeController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        //this.router.post('/', this.checkAuth, this.Controller.recipePost.bind(this.Controller));
        //this.router.get('/', this.checkAuth, this.Controller.recipesGetAllForUser.bind(this.Controller));
        //this.router.delete('/:productId', this.checkAuth, this.Controller.recipeDelete.bind(this.Controller));
        //this.router.patch('/:productId', this.checkAuth, this.Controller.recipePatch.bind(this.Controller));
        //this.router.patch('/setFavorite', this.checkAuth, this.Controller.recipeSetFavorite.bind(this.Controller));
        //this.router.get('/report/:productId', this.checkAuth, this.Controller.recipeReport.bind(this.Controller));
    }
}
exports.default = RecipeRouter;
//# sourceMappingURL=recipeRouter.js.map