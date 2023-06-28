"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const morgan = require("morgan");
const recipeRouter_1 = __importDefault(require("./api/router/recipeRouter"));
const groupRouter_1 = __importDefault(require("./api/router/groupRouter"));
const userRouter_1 = __importDefault(require("./api/router/userRouter"));
const ingredientRouter_1 = __importDefault(require("./api/router/ingredientRouter"));
const adminUserRouter_1 = __importDefault(require("./api/router/adminUserRouter"));
const authentificationRouter_1 = __importDefault(require("./api/router/authentificationRouter"));
class Application {
    constructor(express) {
        this.app = express;
        this.authentificationRoutes = new authentificationRouter_1.default();
        this.recipeRoutes = new recipeRouter_1.default();
        this.groupRoutes = new groupRouter_1.default();
        this.userRoutes = new userRouter_1.default();
        this.ingredientRoutes = new ingredientRouter_1.default();
        this.adminUserRoutes = new adminUserRouter_1.default();
        this.initializeMiddleware();
        this.initializeRoutes();
        this.initializeErrorHandlers();
    }
    initializeMiddleware() {
        this.app.use(morgan('dev'));
        this.app.use(express.json());
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
            if (req.method === 'OPTIONS') {
                res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE');
                return res.status(200).json({});
            }
            next();
        });
    }
    initializeRoutes() {
        this.app.use('/auth', this.authentificationRoutes.getRouter());
        this.app.use('/recipe', this.recipeRoutes.getRouter());
        this.app.use('/group', this.groupRoutes.getRouter());
        this.app.use('/user', this.userRoutes.getRouter());
        this.app.use('/ingredient', this.ingredientRoutes.getRouter());
        this.app.use('/admin', this.adminUserRoutes.getRouter());
    }
    initializeErrorHandlers() {
        this.app.use((req, res) => {
            console.log('Start');
            const error = new Error('Not found');
            res.status(404).json({
                error: {
                    message: error.message,
                }
            });
        });
    }
}
exports.default = Application;
//# sourceMappingURL=application.js.map