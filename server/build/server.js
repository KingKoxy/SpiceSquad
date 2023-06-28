"use strict";
/**
 * @fileoverview Server class.
 * @package
 * @module server
 * @requires express
 * @requires application
 * @requires firebase-admin
 * @requires dotenv
 * @requires database
 * @class Server
 * @description This class is used to start the server.
 * @exports Server
 * @version 0.1.1
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const application_1 = __importDefault(require("./application"));
const firebase = require("firebase-admin");
require("dotenv/config");
const database_1 = __importDefault(require("./database"));
class Server {
    constructor() {
        this.port = parseInt(process.env.SV_PORT) || 3000;
        this.firebase_credentials = require('../firebase_credentials.json');
    }
    /**
     * @function start
     * @description This function starts the server.
     * @memberof Server
     * @instance
     * @returns {void}
     * @example
     * const server = new Server();
     * server.start();
     */
    start() {
        this.connectToDatabase();
        this.connectToFirebase();
        this.createServer();
    }
    stop() {
        firebase.database().goOffline();
    }
    connectToDatabase() {
        this.database = new database_1.default();
        return true;
    }
    connectToFirebase() {
        firebase.initializeApp({
            credential: firebase.credential.cert(this.firebase_credentials)
        });
        console.log('Firebase connection established');
        return true;
    }
    createServer() {
        this.express = express();
        this.express.listen(this.port, () => console.log(`Listen on port ${this.port}`));
        this.application = new application_1.default(this.express);
    }
}
const server = new Server();
server.start();
//# sourceMappingURL=server.js.map