/**
 * @fileoverview Server class.
 * @package
 * @module server
 * @requires express
 * @requires application
 * @requires firebase-admin
 * @requires dotenv
 * @requires database
 * @requires firebase_credentials.json
 * @class Server
 * @description This class is used to start the server.
 * @exports Server
 * @version 0.1.1
 */

import express = require("express");
import Application from "./application";
import firebase = require("firebase-admin");
import "dotenv/config";

class Server {
  private port: number = parseInt(process.env.SV_PORT) || 3000;
  private firebase_credentials: any = require("../firebase_credentials.json");
  private express: express.Application;
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

  private connectToDatabase(): boolean {
    return true;
  }

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
