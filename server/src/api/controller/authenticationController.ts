import express = require('express')
import AbstractController from './abstractController'
import firebaseAuth = require('firebase/auth')

/**
 * @description This class contains the router for the authentication router.
 * @class AuthenticationRouter
 * @extends abstractRouter
 * @exports AuthenticationRouter
 * @version 1.0.0
 * @requires AuthenticationController
 * @requires express
 * @requires AbstractController
 * @requires firebase
 * @requires firebaseAdmin
 * @requires firebaseAuth
 */
export default class AuthenticationController extends AbstractController {
    /**
     * @description This constructor calls the constructor of the abstractController.
     * @constructor
     * @param void
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
                    user: userCredentials.user,
                    //refreshToken: userCredentials.user.refreshToken,
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
                const uuid = userCredentials.user.uid
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
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async userRefreshToken(
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
    ): Promise<void> {
        return this.auth
            .updateCurrentUser(this.auth.currentUser)
            .then(async (token) => {
                console.log('Successfully logged in:', token)
                res.status(200).json({
                    idToken: token,
                })
            })
            .catch((error) => {
                res.status(402).json({
                    error: 'An error occurred.',
                    'error message': error,
                })
            })
    }

    /**
     * @description This function logs a user out.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async userLogout(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        await firebaseAuth.signOut(this.auth).then(() => {
            res.status(200).json({
                message: 'Successfully logged out',
            })
        })
    }
}
