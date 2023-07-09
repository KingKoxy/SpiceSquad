import express = require('express')
import AbstractController from './abstractController'

export default class AdminUserController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
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
    try {
      // Check if user is already an admin
      await this.prisma.admin
        .findFirst({
          where: {
            user_id: req.params.targetId,
            group_id: req.params.groupId,
          },
        })
        .then((result) => {
          if (result) {
            req.statusCode = 422
            throw new Error('User is already an admin!')
          }
        })

      // Create admin
      await this.prisma.admin
        .create({
          data: {
            user_id: req.params.targetId,
            group_id: req.params.groupId,
          },
        })
        .then(() => {
          res.status(200).json({
            message: 'Admin created successfully!',
          })
        })
        .catch((error) => {
          req.statusCode = 422
          throw new Error(error)
        })
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function removes an admin from a group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async removeAdmin(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    try {
      // Check if user is admin
      await this.prisma.admin
        .findFirst({
          where: {
            user_id: req.params.targetId,
            group_id: req.params.groupId,
          },
        })
        .then((result) => {
          if (!result) {
            req.statusCode = 422
            throw new Error('User is not an admin!')
          }
        })

      // Remove admin
      await this.prisma.admin
        .deleteMany({
          where: {
            user_id: req.params.targetId,
            group_id: req.params.groupId,
          },
        })
        .then(() => {
          res.status(200).json({
            message: 'Admin removed successfully!',
          })
        })
        .catch((error) => {
          req.statusCode = 422
          throw new Error(error)
        })
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function kicks a user from a group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async kickUser(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    // Kick user
    this.prisma.groupMember
      .deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })
      .then((result) => {
        // Remove admin
        this.prisma.admin
          .deleteMany({
            where: {
              user_id: req.params.targetId,
              group_id: req.params.groupId,
            },
          })
          .catch((error) => {
            req.statusCode = 422
            next(new Error(error))
          })

        res.status(200).json({
          message: 'User kicked successfully!',
        })
      })
      .catch((error) => {
        req.statusCode = 422
        next(new Error(error))
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
    try {
      const existingBannedUser = await this.prisma.bannedUser.findFirst({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      if (existingBannedUser) {
        res.status(422).json({
          message: 'User is already banned!',
        })
        return
      }

      await this.prisma.groupMember.deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      await this.prisma.admin.deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      await this.prisma.bannedUser.create({
        data: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      res.status(200).json({
        message: 'User banned successfully!',
      })
    } catch (error) {
      req.statusCode = 422
      next(error)
    }
  }

  /**
   * @description This function sets a recipe to censored.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async setCensored(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    try {
      // Find the author of the recipe
      const result = await this.prisma.recipe.findFirst({
        where: {
          id: req.params.recipeId,
        },
      })

      if (!result) {
        req.statusCode = 422
        throw new Error('Recipe does not exist!')
      }
      await this.prisma.groupMember
        .findFirst({
          where: {
            user_id: result.author_id,
          },
        })
        .then((result) => {
          if (!result) {
            req.statusCode = 422
            throw new Error('Recipe author is not a member of the group!')
          }
        })

      // Check if recipe is already censored
      await this.prisma.censoredRecipe
        .findFirst({
          where: {
            recipe_id: req.params.recipeId,
            group_id: req.params.groupId,
          },
        })
        .then((result) => {
          if (result) {
            req.statusCode = 422
            throw new Error('Recipe is already censored!')
          }
        })

      // Censor recipe
      this.prisma.censoredRecipe
        .create({
          data: {
            recipe_id: req.params.recipeId,
            group_id: req.params.groupId,
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
          throw new Error(error)
        })
    } catch (error) {
      next(error)
    }
  }
}
