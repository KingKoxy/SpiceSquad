"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const abstractController_1 = __importDefault(require("./abstractController"));
const mailSender_1 = __importDefault(require("../../mailer/mailSender"));
const reportMailWrapper_1 = __importDefault(require("../../mailer/mailBuilder/reportMailWrapper"));
class RecipeController extends abstractController_1.default {
    constructor() {
        super();
        this.mailSender = new mailSender_1.default();
        this.reportMailBuilder = new reportMailWrapper_1.default();
    }
    recipePost(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const requireParams = ["title", 'author_id', 'image', 'duration', 'difficulty', 'ingredients', 'instructions', 'is_vegetarian', 'is_vegan', 'is_gluten_free', 'is_kosher', 'is_halal', 'is_private', 'default_portions'];
            const missingParams = requireParams.filter(param => !(param in req.body));
            if (missingParams.length > 0) {
                res.status(400).json({
                    error: 'Missing parameters: ' + missingParams.join(', ')
                });
                return;
            }
            this.pool.query('INSERT INTO "recipe" (title, author_id, image, duration, difficulty, instructions, is_vegetarian, is_vegan, is_gluten_free, is_kosher, is_halal, is_private, default_portions) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING id', [req.body.title, req.body.author_id, req.body.image, req.body.duration, req.body.difficulty, req.body.instructions, req.body.is_vegetarian, req.body.is_vegan, req.body.is_gluten_free, req.body.is_kosher, req.body.is_halal, req.body.is_private, req.body.default_portions])
                .then((result) => {
                for (const ingredient of req.body.ingredients) {
                    const requireParams = ['name', 'icon_name', 'amount', 'unit'];
                    const missingParams = requireParams.filter(param => !(param in ingredient));
                    if (missingParams.length > 0) {
                        res.status(400).json({
                            error: 'Missing parameters: ' + missingParams.join(', ')
                        });
                        return;
                    }
                    this.pool.query('INSERT INTO ingredient (name, icon_name, amount, unit, recipe_id) VALUES ($1, $2, $3, $4, $5)', [ingredient.name, ingredient.icon_name, ingredient.amount, ingredient.unit, result.rows[0].id]);
                }
                res.status(200).json({
                    message: "Recipe created successfully!",
                });
            });
        });
    }
    ;
    recipeDelete(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const requireParams = ["recipe_id"];
            const missingParams = requireParams.filter(param => !(param in req.body));
            if (missingParams.length > 0) {
                res.status(400).json({
                    error: 'Missing parameters: ' + missingParams.join(', ')
                });
                return;
            }
            this.pool.query('DELETE FROM "recipe" WHERE id = $1', [req.body.recipe_id])
                .then((result) => {
                res.status(200).json({
                    message: "Recipe deleted successfully!",
                });
            });
        });
    }
    ;
    recipePatch(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const requireParams = ["recipe_id", "user_id", "title", 'image', 'duration', 'difficulty', 'instructions', 'is_vegetarian', 'is_vegan', 'is_gluten_free', 'is_kosher', 'is_halal', 'is_private', 'default_portions'];
            const missingParams = requireParams.filter(param => !(param in req.body));
            if (missingParams.length > 0) {
                res.status(400).json({
                    error: 'Missing parameters: ' + missingParams.join(', ')
                });
                return;
            }
            const result = yield this.pool.query('SELECT author_id FROM "recipe" WHERE id = $1', [req.body.recipe_id]);
            console.log(result.rows[0].author_id);
            console.log(req.body.user_id);
            if (req.body.user_id != result.rows[0].author_id) {
                res.status(401).json({
                    error: 'You are not authorized to edit this recipe!'
                });
                return;
            }
            this.pool.query('UPDATE "recipe" SET title = $1, image = $2, duration = $3, difficulty = $4, instructions = $5, is_vegetarian = $6, is_vegan = $7, is_gluten_free = $8, is_kosher = $9, is_halal = $10, is_private = $11, default_portions = $12 WHERE id = $13', [req.body.title, req.body.image, req.body.duration, req.body.difficulty, req.body.instructions, req.body.is_vegetarian, req.body.is_vegan, req.body.is_gluten_free, req.body.is_kosher, req.body.is_halal, req.body.is_private, req.body.default_portions, req.body.recipe_id])
                .then((result) => {
                for (const ingredient of req.body.ingredients) {
                    const requireParams = ['name', 'icon_name', 'amount', 'unit'];
                    const missingParams = requireParams.filter(param => !(param in ingredient));
                    if (missingParams.length > 0) {
                        res.status(400).json({
                            error: 'Missing parameters: ' + missingParams.join(', ')
                        });
                        return;
                    }
                    this.pool.query('UPDATE ingredient SET name = $1, icon_name = $2, amount = $3, unit = $4 WHERE id = $5', [ingredient.name, ingredient.icon_name, ingredient.amount, ingredient.unit, ingredient.id]);
                }
                res.status(200).json({
                    message: "Recipe updated successfully!",
                });
            });
        });
    }
    ;
    recipesGetAllForUser(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield this.pool.query('SELECT * FROM "recipe" WHERE author_id = $1', [req.params.userId]);
            const recipes = result.rows;
            for (const recipe of recipes) {
                const result = yield this.pool.query('SELECT * FROM ingredient WHERE recipe_id = $1', [recipe.id]);
                recipe.ingredients = result.rows;
            }
            res.status(200).json({
                recipes: recipes,
            });
        });
    }
    recipeReport(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: "Recipe reported successfully!",
            });
        });
    }
    recipeSetFavorite(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const requireParams = ["user_id", "is_favorite"];
            const missingParams = requireParams.filter(param => !(param in req.body));
            if (missingParams.length > 0) {
                res.status(400).json({
                    error: 'Missing parameters2: ' + missingParams.join(', ')
                });
                return;
            }
            const isInTable = yield this.pool.query('SELECT COUNT(*) FROM "favorite" WHERE user_id = $1 AND recipe_id = $2', [req.body.user_id, req.params.productId]);
            if (req.body.is_favorite && isInTable.rows[0].count == 0) {
                this.pool.query('INSERT INTO "favorite" (user_id, recipe_id) VALUES ($1, $2)', [req.body.user_id, req.params.productId])
                    .then((result) => {
                    res.status(200).json({
                        message: "Recipe set as favorite successfully!",
                    });
                });
            }
            else if (!req.body.is_favorite && isInTable.rows[0].count > 0) {
                this.pool.query('DELETE FROM favorite WHERE recipe_id = $1', [req.params.productId])
                    .then((result) => {
                    res.status(200).json({
                        message: "Recipe removed from favorites successfully!",
                    });
                });
            }
            else if (!req.body.is_favorite && isInTable.rows[0].count == 0) {
                res.status(200).json({
                    message: "Recipe already not in favorites!",
                });
            }
            else {
                res.status(200).json({
                    message: "Recipe already in favorites!",
                });
            }
        });
    }
}
exports.default = RecipeController;
//# sourceMappingURL=recipeController.js.map