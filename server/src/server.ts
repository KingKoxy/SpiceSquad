/**
 * @fileoverview Server class.
 * @module server
 * @requires express
 * @requires application
 * @requires firebase-admin
 * @requires dotenv
 * @requires firebase_credentials.json
 * @class Server
 * @description This class is used to start the server.
 * @exports Server
 * @version 1.0.0
 */

import express = require("express");
import Application from "./application";
import firebase = require("firebase-admin");
import "dotenv/config";

class Server {
  
  /**
   * @description This property contains the port.
   * @memberof Server
   * @private
   * @type {number}
   */
  private port: number = parseInt(process.env.SV_PORT) || 3000;

  /**
   * @description This property contains the firebase credentials.
   * @memberof Server
   * @private
   * @type {*}
   * @requires firebase_credentials.json
   */
  private firebase_credentials: any = require("../firebase_credentials.json");

  /**
   * @description This property contains the express application.
   * @memberof Server
   * @private
   * @type {express.Application}
   * @requires express
   */
  private express: express.Application;

  /**
   * @description This property contains the application.
   * @memberof Server
   * @private
   * @type {Application}
   * @requires Application
   */
  private application: Application;


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
    if (this.connectToDatabase() && this.connectToFirebase()) {
      if (this.createServer()) {
        console.log("Server started");
        console.log(`Listen on port ${this.port}`)
      } else {
        console.log("Server failed to start");
      }
    } else {
      console.log("Server failed to start");
    }
  }

  /**
   * @description This function connects to the database.
   * @memberof Server
   * @private
   * @returns {boolean} True if the connection to the database was successful, false otherwise.
   */
  private connectToDatabase(): boolean {
    return true;
  }

  /**
   * @description This function connects to firebase.
   * @memberof Server
   * @private
   * @returns {boolean} True if the connection to firebase was successful, false otherwise.
   */
  private connectToFirebase(): boolean {
    try {
      firebase.initializeApp({
        credential: firebase.credential.cert(this.firebase_credentials),
      });
      console.log("Firebase connection established");
      return true;
    } catch (error) {
      console.log("Firebase connection failed");
      return false;
    }
  }

  /**
   * @description This function creates the server.
   * @memberof Server
   * @private
   * @returns {boolean} True if the server was created successfully, false otherwise.
   */
  private createServer(): boolean {
    try {
      this.express = express();
      this.express.listen(this.port);
      this.application = new Application(this.express);
      return true;
    } catch (error) {
      console.log("Server connection failed");
      if (process.env.NODE_ENV !== "production") {
        console.log(error);
      }
      return false;
    }
  }
}

const server = new Server();
server.start();
