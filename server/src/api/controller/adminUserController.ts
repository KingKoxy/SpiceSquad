import express = require('express')
import AbstractController from './abstractController'

/**
 * @description This class contains the router for the admin user router.
 * @class AdminUserRouter
 * @extends abstractRouter
 * @exports AdminUserRouter
 * @version 1.0.0
 * @requires AdminUserController
 * @requires express
 * @requires AbstractController
 */
export default class AdminUserController extends AbstractController {
    /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void

   */
    constructor() {
        super()
    }

    //TODO: Add member check in middleware
    /**
     * @description This function adds a user to a group.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async makeAdmin(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        this.prisma.admin
            .create({
                data: {
                    user_id: req.body.targetId,
                    group_id: req.body.groupId,
                },
            })
            .then((result) => {
                res.status(200).json({
                    message: 'Admin created successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 422
                next(error)
            })
    }

    /**
     * @description This function removes an admin from a group.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async removeAdmin(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        this.prisma.admin
            .deleteMany({
                where: {
                    user_id: req.body.targetId,
                    group_id: req.body.groupId,
                },
            })
            .then((result) => {
                res.status(200).json({
                    message: 'Admin removed successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 422
                next(error)
            })
    }

    /**
     * @description This function kicks a user from a group.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async kickUser(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        this.prisma.groupMember
            .deleteMany({
                where: {
                    user_id: req.body.targetId,
                    group_id: req.body.groupId,
                },
            })
            .then((result) => {
                res.status(200).json({
                    message: 'User kicked successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 422
                next(error)
            })
    }

    /**
     * @description This function bans a user from a group.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async banUser(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        this.prisma.groupMember
            .deleteMany({
                where: {
                    user_id: req.body.targetId,
                    group_id: req.body.groupId,
                },
            })
            .then((result) => {})

        this.prisma.bannedUser
            .create({
                data: {
                    user_id: req.body.targetId,
                    group_id: req.body.groupId,
                },
            })
            .then((result) => {
                res.status(200).json({
                    message: 'User banned successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 422
                next(error)
            })
    }

    /**
     * @description This function sets a recipe to censored.
     * @param req Express request handler
     * @param res Express response handler
     * @param next Express next function (for error handling)
     * @returns Promise<void>
     */
    public async setCensored(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        this.prisma.censoredRecipe
            .create({
                data: {
                    recipe_id: req.body.recipe_id,
                    group_id: req.body.group_id,
                },
            })
            .then((result) => {
                console.log(result)
                res.status(200).json({
                    message: 'Recipe censored successfully!',
                })
            })
            .catch((error) => {
                req.statusCode = 422
                next(error)
            })
    }
}
