import express = require('express')
import AbstractController from './abstractController'
import firebaseAuth = require('firebase/auth')
import request = require('request')

export default class AuthenticationController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @returns void
   */
  constructor() {
    super()
  }

  /**
   * @description This function logs a user in.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userLogin(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    firebaseAuth
      .signInWithEmailAndPassword(this.auth, req.body.email, req.body.password)
      .then(async (userCredentials) => {
        console.log('Successfully logged in:', userCredentials.user)
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
        })
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
  }

  /**
   * @description This function registers a user.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userRegister(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    firebaseAuth
      .createUserWithEmailAndPassword(this.auth, req.body.email, req.body.password)
      .then(async (userCredentials) => {
        console.log('Successfully created new user:', userCredentials.user)
        await this.prisma.user.create({
          data: {
            user_name: req.body.userName,
            email: req.body.email,
            firebase_user_id: userCredentials.user.uid,
            created_groups: 0,
          },
        })
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
        })
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
  }

  /**
   * @description This function resets a user's password.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public userResetPassword(req: express.Request, res: express.Response, next: express.NextFunction): void {
    firebaseAuth
      .sendPasswordResetEmail(this.auth, req.body.email)
      .then(() => {
        res.status(200).json({
          message: 'Reset email sent successfully.',
        })
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
  }

  /**
   * @description This function refreshes a user's token.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async userRefreshToken(req: express.Request, res: express.Response): Promise<void> {
    console.log('refresh token', req.body.refreshToken)
    const url = process.env.FB_URL;
    const formData = {
      grant_type: 'refresh_token',
      refresh_token: req.body.refreshToken
    };
  
    request.post(
      {
        url: url,
        form: formData,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      },
      (error, response, body) => {
        if (error) {
          // Fehlerbehandlung
          res.status(500).json({ error: 'Fehler beim updaten des ID-Tokens' });
        } else {
          const data = JSON.parse(body);
          const idToken = data.id_token;
          // Handle the refreshed ID token
          res.json({ idToken: idToken });
        }
      }
    );
  }

  /**
   * @description This function logs a user out.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async userLogout(req: express.Request, res: express.Response): Promise<void> {
    await firebaseAuth.signOut(this.auth).then(() => {
      res.status(200).json({
        message: 'Successfully logged out',
      })
    })
  }
}
