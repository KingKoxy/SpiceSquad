import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'
import GroupController from './groupController'
import ImageController from './imageController'

export default class UserController extends AbstractController {
  groupController: GroupController;
  ImageController: ImageController;

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
    this.ImageController = new ImageController()
    this.groupController = new GroupController()
  }

  /**
   * @description This function deletes a user.
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
        profileImage: Uint8Array | ''
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const oldUserData = await this.prisma.user.findUnique({ where: { id: req.userId } })
    const imageId = await this.ImageController.checkImageParamType(req.body.profileImage);
    if (oldUserData.profile_image != null && imageId != oldUserData.profile_image) {
      console.log(oldUserData.profile_image)
      this.ImageController.deleteImage(oldUserData.profile_image);
    }


    const newUserData = await this.prisma.user
      .update({
        where: {
          id: req.userId,
        },
        data: {
          user_name: req.body.name,
          email: req.body.email,
          profile_image: imageId,
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
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async userGet(req: AuthenticatedRequest, res: express.Response): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id: req.userId } })
    console.log(user)
    const userWithImageLink = { ...user, profile_image: process.env.IMAGE_URL + user.profile_image}
    
    res.status(200).json(userWithImageLink)
  }
}
