"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
class abstractRouter {
    constructor() {
        this.router = express.Router();
    }
    getRouter() {
        return this.router;
    }
    ;
}
exports.default = abstractRouter;
//# sourceMappingURL=abstractRouter.js.map