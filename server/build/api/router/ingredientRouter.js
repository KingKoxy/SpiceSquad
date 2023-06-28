"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ingredientController_1 = __importDefault(require("../controller/ingredientController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class IngredientRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new ingredientController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        this.router.get('/', this.checkAuth, this.Controller.ingredientsGet.bind(this.Controller));
    }
}
exports.default = IngredientRouter;
//# sourceMappingURL=ingredientRouter.js.map