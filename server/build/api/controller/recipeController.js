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
class RecipeController extends abstractController_1.default {
    constructor() {
        super();
    }
    recipePost(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Handling POST requests to /recipes'
            });
            // TODO: Implement
        });
    }
    ;
    recipeDelete(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Deleted recipe!'
            });
            // TODO: Implement
        });
    }
    ;
    recipePatch(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Updated recipe!'
            });
            // TODO: Implement
        });
    }
    ;
    recipesGetAllForUser(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Handling GET requests to /recipes'
            });
            // TODO: Implement
        });
    }
    recipeReport(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Handling GET requests to /report'
            });
            // TODO: Implement
        });
    }
    recipeSetFavorite(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Handling PATCH requests to /setFavorite'
            });
        });
    }
}
exports.default = RecipeController;
//# sourceMappingURL=recipeController.js.map