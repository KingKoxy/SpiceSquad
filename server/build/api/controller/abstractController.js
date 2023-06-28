"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const database_1 = __importDefault(require("./../../database"));
class AbstractController {
    constructor() {
        this.database = new database_1.default();
        this.pool = this.database.getPool();
    }
}
exports.default = AbstractController;
//# sourceMappingURL=abstractController.js.map