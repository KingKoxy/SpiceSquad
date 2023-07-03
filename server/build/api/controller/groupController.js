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
class GroupController extends abstractController_1.default {
    constructor() {
        super();
    }
    groupPost(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const requireParams = ["name"];
            const missingParams = requireParams.filter(param => !(param in req.body));
            if (missingParams.length > 0) {
                res.status(400).json({
                    error: 'Missing parameters: ' + missingParams.join(', ')
                });
                return;
            }
            this.pool.query('INSERT INTO "group" (name) VALUES ($1) RETURNING id', [req.body.name])
                .then((result) => {
                this.pool.query('INSERT INTO "groupmember" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
                this.pool.query('INSERT INTO "admin" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
                res.status(200).json({
                    message: "Group created successfully!",
                });
            });
        });
    }
    groupDelete(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Deleted group!'
            });
        });
    }
    groupPatch(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Updated group!'
            });
        });
    }
    groupJoin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Joined group!'
            });
        });
    }
    groupLeave(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Left group!'
            });
        });
    }
    groupGetAllForUser(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            res.status(200).json({
                message: 'Handling GET requests to /groups'
            });
        });
    }
}
exports.default = GroupController;
//# sourceMappingURL=groupController.js.map