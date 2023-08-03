import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'
import GroupController from './groupController'

export default class UserController extends AbstractController {
  groupController: GroupController;

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
    this.groupController = new GroupController()
  }

  /**
   * @description This function deletes the user making the request.
   * @param req AuthenticatedRequest<never,never,never> 
   * @param res Express response containing message
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userDelete(
    req: AuthenticatedRequest<never, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.groupMember.findMany({
      where: {
        user_id: req.userId,
      }

    }).then((groupMembers) => {
      groupMembers.forEach((groupMember) => {
        this.prisma.groupMember.delete({
          where: {
            id: groupMember.id,
          },
        }).then((group) => {
          this.groupController.checkGroupEmpty(group.group_id)
        }
        )
      })
      })
    
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
   * @description This function updates a user in the database.
   * @param req AuthenticatedRequest<never,never,{name:string,email:string,profileImage:Uint8Array|null}>
   * @param res Express response containing message
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
    const oldUserData = await this.prisma.user.findUnique({ where: { id: req.userId } })
    const newUserData = await this.prisma.user
      .update({
        where: {
          id: req.userId,
        },
        data: {
          user_name: req.body.name,
          email: req.body.email,
          profile_image: req.body.profileImage?Buffer.from(req.body.profileImage): null,
        },
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
    if (newUserData && (oldUserData.email !== req.body.email)) {
      this.firebaseAdmin
        .auth()
        .updateUser(newUserData.firebase_user_id, { email: req.body.email })
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
   * @param req AuthenticatedRequest<never,never,never>
   * @param res Express response containing the user
   * @returns Promise<void>
   */
  public async userGet(req: AuthenticatedRequest, res: express.Response): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id: req.userId } })
    res.json(user)
  }
}
