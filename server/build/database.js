"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const pg_1 = __importDefault(require("pg"));
class Database {
    constructor() {
        this.dbConfig = {
            user: process.env.PG_USER,
            host: process.env.PG_HOST,
            database: process.env.PG_DATABASE,
            password: process.env.PG_PASSWORD,
            port: process.env.PG_PORT,
        };
        if (!Database.instance) {
            this.createPool();
            Database.instance = this;
        }
        return Database.instance;
    }
    createPool() {
        try {
            this.pool = new pg_1.default.Pool(this.dbConfig);
        }
        catch (error) {
            console.error('Fehler beim Erstellen des Pools:', error);
        }
    }
    getPool() {
        return this.pool;
    }
}
exports.default = Database;
//# sourceMappingURL=database.js.map