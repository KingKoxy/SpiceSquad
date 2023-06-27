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

import express = require('express');
import Application from './application';
import firebase = require('firebase-admin');
import 'dotenv/config'
import Database from './database';


class Server {

    private port: number = parseInt(process.env.SV_PORT) || 3000;
    private firebase_credentials: any = require('../firebase_credentials.json');
    private express: express.Application;
    private application: Application;
    private database: Database;

    constructor() {
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
    public start(): void {
        this.connectToDatabase();
        this.connectToFirebase();
        this.createServer();
    }

    public stop(): void {
        firebase.database().goOffline()
    }

    private connectToDatabase(): boolean {
        this.database = new Database();
        return true;
    }

    private connectToFirebase(): boolean {
        firebase.initializeApp({
            credential: firebase.credential.cert(this.firebase_credentials)
        });
        console.log('Firebase connection established');
        return true;
    }

    private createServer(): void {
        this.express = express();
        this.express.listen(this.port, () => console.log(`Listen on port ${this.port}`));
        this.application = new Application(this.express);
        
    }
}

const server = new Server();
server.start();
