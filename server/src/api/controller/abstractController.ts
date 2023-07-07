import { PrismaClient } from "@prisma/client";
import firebase = require("firebase/app");
import firebaseAdmin = require("firebase-admin");
import firebaseAuth = require("firebase/auth");

/**
 * @description This class contains the router for the authentification router.
 * @class AuthentificationRouter
 * @extends abstractRouter
 * @exports AuthentificationRouter
 * @version 1.0.0
 * @requires AuthentificationController
 * @requires express
 * @requires firebase
 * @requires firebaseAdmin
 * @requires firebaseAuth
 */
abstract class AbstractController {

  
  /**
   * @description This variable contains the firebase config.
   * @private
   */
  private firebaseConfig = {
    apiKey: process.env.FB_API_KEY,
    authDomain: process.env.FB_AUTH_DOMAIN,
    databaseURL: process.env.FB_DATABASE_URL,
    projectId: process.env.FB_PROJECT_ID,
    storageBucket: process.env.FB_STORAGE_BUCKET,
    messagingSenderId: process.env.FB_MESSAGING_SENDER_ID,
    appId: process.env.FB_APP_ID,
  };

  /**
   * @description This variable contains the firebase admin config.
   * @protected
   */
  protected firebaseAdmin = firebaseAdmin;

  /**
   * @description This variable contains the firebase auth config.
   * @protected
   * @type {firebaseAuth.Auth}
   */
  protected firebaseAuth = firebaseAuth;

  /**
   * @description This variable contains the firebase auth instance.
   * @protected
   * @type {firebaseAuth.Auth}
   */
  protected auth: firebaseAuth.Auth;

  
  /**
   * @description This variable contains the prisma client.
   * @protected
   * @type {PrismaClient}
   */
  protected prisma: PrismaClient;

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void
   * @returns void
   */
  constructor() {
    this.prisma = new PrismaClient();
    firebase.initializeApp(this.firebaseConfig);
    this.auth = firebaseAuth.getAuth();
  }
}
export default AbstractController;