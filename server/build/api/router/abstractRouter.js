"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const checkAuthorization_1 = __importDefault(require("../middleware/checkAuthorization"));
class abstractRouter {
    constructor() {
        this.router = express.Router();
        this.checkAuthorization = new checkAuthorization_1.default();
        this.checkAuth = this.checkAuthorization.checkAuthorization.bind(this.checkAuthorization);
    }
    getRouter() {
        return this.router;
    }
    ;
}
exports.default = abstractRouter;
//# sourceMappingURL=abstractRouter.js.map