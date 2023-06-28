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
class AdminUserController extends abstractController_1.default {
    constructor() {
        super();
    }
    makeAdmin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                res.status(200).json({
                    message: 'Handling POST request to /admin/user'
                });
            }
            catch (error) {
                res.status(500).json({ error: 'Internal server error' });
            }
        });
    }
    removeAdmin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                res.status(200).json({
                    message: 'Handling DELETE request to /admin/user'
                });
            }
            catch (error) {
                res.status(500).json({ error: 'Internal server error' });
            }
        });
    }
    kickUser(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                res.status(200).json({
                    message: 'Handling DELETE request to /admin/user'
                });
            }
            catch (error) {
                res.status(500).json({ error: 'Internal server error' });
            }
        });
    }
    banUser(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                res.status(200).json({
                    message: 'Handling DELETE request to /admin/user'
                });
            }
            catch (error) {
                res.status(500).json({ error: 'Internal server error' });
            }
        });
    }
    setCensored(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                res.status(200).json({
                    message: 'Handling PUT request to /admin/user'
                });
            }
            catch (error) {
                res.status(500).json({ error: 'Internal server error' });
            }
        });
    }
}
exports.default = AdminUserController;
//# sourceMappingURL=adminUserController.js.map