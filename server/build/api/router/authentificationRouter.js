"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const authentificationController_1 = __importDefault(require("../controller/authentificationController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class AuthentificationRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new authentificationController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        this.router.post('/register', this.Controller.userRegister.bind(this.Controller));
        this.router.post('/login', this.Controller.userLogin.bind(this.Controller));
        this.router.post('/resetPassword', this.Controller.userResetPassword.bind(this.Controller));
        this.router.get('/getUserByToken', this.Controller.getUserByToken.bind(this.Controller));
        this.router.get('/refreshToken', this.Controller.userRefreshToken.bind(this.Controller));
        this.router.get('/logout', this.Controller.userLogout.bind(this.Controller));
    }
}
exports.default = AuthentificationRouter;
//# sourceMappingURL=authentificationRouter.js.map