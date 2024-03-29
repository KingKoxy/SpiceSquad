import firebase = require('firebase-admin')
import express = require('express')
import AbstractMiddleware from './abstractMiddleware'
import AuthenticatedRequest from './authenticatedRequest'

/**
 * @class CheckAuthorization
 * @description This class is used to check the authorization of a request.
 * @exports CheckAuthorization
 * @version 1.0.0
 * @extends AbstractMiddleware
 * @requires firebase
 * @requires express
 * @requires AbstractMiddleware
 */
export default class CheckAuthorization extends AbstractMiddleware {
  /**
   * @constructor This constructor initializes the check authorization middleware.
   * @memberof CheckAuthorization
   */
  constructor() {
    super()
  }

  /**
   * @description This function checks the authorization of a request and adds the user's id to the request's body.
   * @memberof CheckAuthorization
   * @param {AuthenticatedRequest} req - The request.
   * @param {express.Response} res - The response.
   * @param {express.NextFunction} next - The next function.
   * @returns {Promise<void>}
   * @public
   * @async
   */
  public async checkAuthorization(
    req: AuthenticatedRequest,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    // Check if authorization header is provided
    if (req.get('Authorization') === undefined) {
      req.statusCode = 401
      next(new Error('No Authorization header provided'))
      return
    }

    // Check if authorization header is valid
    const token = req.get('Authorization')
    let uid: string
    firebase
      .auth()
      .verifyIdToken(token)
      .then(async (decodedToken) => {
        uid = decodedToken.uid
        await this.prisma.user
          .findUnique({
            where: {
              firebase_user_id: uid,
            },
          })
          .then((user) => {
            // Development only output
            process.env.NODE_ENV === 'development' ? console.log(user) : null
            req.userId = user.id
          })
        next()
      })
      .catch((error) => {
        error as Error
        error.message = 'Invalid authorization please provide a valid token.'
        req.statusCode = 401
        next(error)
      })
  }
}
