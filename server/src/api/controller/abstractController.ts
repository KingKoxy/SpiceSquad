import { PrismaClient } from '@prisma/client'
import firebase = require('firebase/app')
import firebaseAdmin = require('firebase-admin')
import firebaseAuth = require('firebase/auth')

abstract class AbstractController {
  /**
   * @description This variable contains the firebase config.
   * @private
   */
  private firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
  }

  /**
   * @description This variable contains the firebase admin config.
   * @protected
   */
  protected firebaseAdmin = firebaseAdmin

  /**
   * @description This variable contains the firebase auth config.
   * @protected
   * @type {firebaseAuth.Auth}
   */
  protected firebaseAuth = firebaseAuth

  /**
   * @description This variable contains the firebase auth instance.
   * @protected
   * @type {firebaseAuth.Auth}
   */
  protected auth: firebaseAuth.Auth

  /**
   * @description This variable contains the prisma client.
   * @protected
   * @type {PrismaClient}
   */
  protected prisma: PrismaClient

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @returns void
   */
  protected constructor() {
    this.prisma = new PrismaClient()
    firebase.initializeApp(this.firebaseConfig)
    this.auth = firebaseAuth.getAuth()
  }
}
export default AbstractController
