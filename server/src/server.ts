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

import express = require('express')
import Application from './application'
import firebase = require('firebase-admin')
import 'dotenv/config'

export default class Server {
  /**
   * @description This property contains the port.
   * @memberof Server
   * @private
   * @type {number}
   */
  private port: number = parseInt(process.env.SV_PORT) || 3000

  /**
   * @description This property contains the express application.
   * @memberof Server
   * @private
   * @type {express.Application}
   * @requires express
   */
  private express: express.Application

  /**
   * @description This property contains the application.
   * @memberof Server
   * @private
   * @type {Application}
   * @requires Application
   */
  private application: Application

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
    if (this.connectToFirebase()) {
      if (this.createServer()) {
        console.log('Server started')
        console.log(`Listen on port ${this.port}`)
      } else {
        console.log('Server failed to start')
      }
    } else {
      console.log('Server failed to start')
    }
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
        credential: firebase.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          // replace `\` and `n` character pairs w/ single `\n` character
          privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
        }),
      })
      console.log('Firebase connection established')
      return true
    } catch (error) {
      console.log('Firebase connection failed')
      return false
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
      this.express = express()
      this.express.listen(this.port)
      this.application = new Application(this.express)
      // Fügen Sie hier eine Zeile hinzu, um die Express-App zu exportieren:
      module.exports.app = this.express
      return true
    } catch (error) {
      console.log('Server connection failed')
      if (process.env.NODE_ENV !== 'production') {
        console.log(error)
      }
      return false
    }
  }
}

const server = new Server()
server.start()
