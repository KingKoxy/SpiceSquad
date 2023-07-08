import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

/**
 * @description This class contains the controller for the user router.
 * @class UserRouter
 * @extends abstractRouter
 * @exports UserRouter
 * @version 1.0.0
 * @requires UserController
 * @requires express
 */
export default class UserController extends AbstractController {
    /**
     * @description This constructor calls the constructor of the abstractController.
     * @constructor
     */
    constructor() {
        super()
    }

    /**
     * @description This function gets all users.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async userDelete(
        req: AuthenticatedRequest<never, never, never>,
        res: express.Response,
        next: express.NextFunction
    ): Promise<void> {
        this.prisma.user
            .delete({
                where: {
                    id: req.userId,
                },
            })
            .then((user) => {
                this.firebaseAdmin
                    .auth()
                    .deleteUser(user.firebase_user_id)
                    .catch((error) => {
                        res.status(500).json({
                            error: error,
                        })
                    })
                res.status(200).json({
                    message: 'User deleted successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 409
                next(error)
            })
    }

    /**
     * @description This function gets all users.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async userPatch(
        req: AuthenticatedRequest<
            never,
            never,
            {
                user: { name: string; email: string; profileImage: any }
            }
        >,
        res: express.Response,
        next: express.NextFunction
    ): Promise<void> {
        this.prisma.user
            .update({
                where: {
                    id: req.userId,
                },
                data: req.body.user,
            })
            .then(() => {
                res.status(200).json({
                    message: 'User updated successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 409
                next(error)
            })
    }

    /**
     * @description This function gets the current user by their token.
     * @param req Express request handler
     * @param res Express response handler
     * @returns Promise<void>
     */
    public async userGet(req: AuthenticatedRequest, res: express.Response): Promise<void> {
        res.json(this.prisma.user.findUnique({ where: { id: req.userId } }))
    }
}
