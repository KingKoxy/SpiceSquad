"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const groupController_1 = __importDefault(require("../controller/groupController"));
const abstractRouter_1 = __importDefault(require("./abstractRouter"));
class GroupRouter extends abstractRouter_1.default {
    constructor() {
        super();
        this.Controller = new groupController_1.default();
        this.setupRoutes();
    }
    setupRoutes() {
        this.router.post('/', this.checkAuth, this.Controller.groupPost.bind(this.Controller));
        this.router.delete('/', this.checkAuth, this.Controller.groupDelete.bind(this.Controller));
        this.router.patch('/', this.checkAuth, this.Controller.groupPatch.bind(this.Controller));
        this.router.patch('/join', this.checkAuth, this.Controller.groupJoin.bind(this.Controller));
        this.router.patch('/leave', this.checkAuth, this.Controller.groupLeave.bind(this.Controller));
        this.router.get('/', this.checkAuth, this.Controller.groupGetAllForUser.bind(this.Controller));
    }
}
exports.default = GroupRouter;
//# sourceMappingURL=groupRouter.js.map