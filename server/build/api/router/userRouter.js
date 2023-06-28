"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const userController_1 = __importDefault(require("../controller/userController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class UserRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new userController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        this.router.delete('/', this.checkAuth, this.Controller.userDelete.bind(this.Controller));
        this.router.patch('/', this.checkAuth, this.Controller.userPatch.bind(this.Controller));
    }
}
exports.default = UserRouter;
//# sourceMappingURL=userRouter.js.map