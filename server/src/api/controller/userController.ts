import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

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
            req.statusCode = 409
            next(error)
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
        name: string
        email: string
        profileImage: Uint8Array | null
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const user = await this.prisma.user
      .update({
        where: {
          id: req.userId,
        },
        data: {
          user_name: req.body.name || undefined,
          email: req.body.email || undefined,
          profile_image: req.body.profileImage?Buffer.from(req.body.profileImage):null || undefined,
        },
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
    if (user && req.body.email !== undefined) {
      this.firebaseAdmin
        .auth()
        .updateUser(user.firebase_user_id, { email: req.body.email })
        .catch((error) => {
          req.statusCode = 409
          next(error)
        })
    }
    res.status(200).json({
      message: 'User updated successfully!',
    })
  }

  /**
   * @description This function gets the current user by their token.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async userGet(req: AuthenticatedRequest, res: express.Response): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id: req.userId } })
    console.log(user)
    res.json(user)
  }
}
