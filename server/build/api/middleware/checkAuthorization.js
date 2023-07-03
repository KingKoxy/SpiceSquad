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
const firebase = require("firebase-admin");
const database_1 = __importDefault(require("../../database"));
class CheckAuthorization {
    constructor() {
        this.database = new database_1.default();
        this.pool = this.database.getPool();
    }
    checkAuthorization(req, res, next) {
        return __awaiter(this, void 0, void 0, function* () {
            const token = req.get('Authorization');
            let uid;
            try {
                firebase.auth().verifyIdToken(token).then((decodedToken) => __awaiter(this, void 0, void 0, function* () {
                    uid = decodedToken.uid;
                    req.body.user_id = (yield this.pool.query('SELECT id FROM "user" WHERE firebase_user_id = $1', [uid])).rows[0].id;
                    next();
                })).catch((error) => {
                    res.status(401).json({ message: 'No valid user' });
                });
            }
            catch (error) {
                res.status(401).json({ message: 'Some error occurred' });
            }
            ;
        });
    }
    ;
}
exports.default = CheckAuthorization;
//# sourceMappingURL=checkAuthorization.js.map