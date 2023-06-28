"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const adminUserController_1 = __importDefault(require("../controller/adminUserController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class AdminUserRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new adminUserController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        this.router.patch('/makeAdmin', this.checkAuth, this.Controller.makeAdmin.bind(this.Controller));
        this.router.patch('/removeAdmin', this.checkAuth, this.Controller.removeAdmin.bind(this.Controller));
        this.router.patch('/kickUser', this.checkAuth, this.Controller.kickUser.bind(this.Controller));
        this.router.patch('/banUser', this.checkAuth, this.Controller.banUser.bind(this.Controller));
        this.router.patch('/setCensored', this.checkAuth, this.Controller.setCensored.bind(this.Controller));
    }
}
exports.default = AdminUserRouter;
//# sourceMappingURL=adminUserRouter.js.map