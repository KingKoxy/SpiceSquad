import express = require('express')
import AbstractController from './abstractController'
import firebaseAuth = require('firebase/auth')
import request = require('request')
import AuthenticatedRequest from '../middleware/authenticatedRequest'

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
  public async userLogin(req: express.Request< never, never, {email: string, password: string}>, res: express.Response, next: express.NextFunction): Promise<void> {
    firebaseAuth
      .signInWithEmailAndPassword(this.auth, req.body.email, req.body.password)
      .then(async (userCredentials) => {
        // Development only output
        if (process.env.NODE_ENV === 'development') console.log('Successfully logged in:', userCredentials.user)
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await userCredentials.user.getIdToken()
        })
      })
      .catch((error) => {
        req.statusCode = 401
        error as Error
        error.message = 'Error logging in user'
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
  public async userRegister(req: express.Request< never, never, { email: string, password: string, userName: string}>, res: express.Response, next: express.NextFunction): Promise<void> {
    // Adds a new user to the firebase authentication
    firebaseAuth
      .createUserWithEmailAndPassword(this.auth, req.body.email, req.body.password)
      .then(async (userCredentials) => {
        // Development only output
        if (process.env.NODE_ENV === 'development') console.log('Successfully created new user:', userCredentials.user.email)
        // Adds a new user to the database
        await this.prisma.user
          .create({
            data: {
              user_name: req.body.userName,
              email: req.body.email,
              firebase_user_id: userCredentials.user.uid,
              created_groups: 0,
            },
          })
          .catch((error) => {
            firebaseAuth.deleteUser(userCredentials.user)
            req.statusCode = 409
            error as Error
            error.message = 'Creating user in database failed'
            next(error)
          })
        res.status(200).json({
          refreshToken: userCredentials.user.refreshToken,
          idToken: await firebaseAuth.getIdToken(userCredentials.user),
        })
        firebaseAuth.sendEmailVerification(userCredentials.user).catch((error) => { next(error) })
      })
      .catch((error) => {
        error as Error
        error.message = 'Error registering user'
        next(error)
      })
  }

  /**
   * @description This function resets a user's password.
   * @param req Express request handler, with the body containing an email as a string
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public userResetPassword(req: express.Request< never, never, {email: string}>, res: express.Response, next: express.NextFunction): void {
    firebaseAuth
      .sendPasswordResetEmail(this.auth, req.body.email)
      .then(() => {
        res.status(200).json({
          message: 'Reset email sent successfully.',
        })
      })
      .catch((error) => {
        req.statusCode = 401
        error as Error
        error.message = 'Error while sending reset email'
        next(error)
      })
  }

  /**
   * @description This function refreshes a user's token.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userRefreshToken(
    req: express.Request< never, never, {refreshToken: string}>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {

    const url = process.env.FIREBASE_URL
    const formData = {
      grant_type: 'refresh_token',
      refresh_token: req.body.refreshToken,
    }

    // Send a POST request to the OAuth endpoint of the Firebase REST API (https://firebase.google.com/docs/reference/rest/auth#section-refresh-token)
    request.post(
      {
        url: url,
        form: formData,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      },
      (error, response, body) => {
        if (error) {
          req.statusCode = 500
          next(new Error('Error while refreshing token'))
        } else {
          const data = JSON.parse(body)
          const idToken = data.id_token
          // Handle the refreshed ID token
          res.json({ idToken: idToken })
        }
      }
    )
  }

  /**
   * @description This function logs out a user.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userLogout(req: AuthenticatedRequest< never, never, never>, res: express.Response, next: express.NextFunction): Promise<void> {
    await firebaseAuth
      .signOut(this.auth)
      .then(() => {
        res.status(200).json({
          message: 'Successfully logged out',
        })
      })
      .catch((error) => {
        req.statusCode = 500
        next(error('Error while logging out'))
      })
  }
}
