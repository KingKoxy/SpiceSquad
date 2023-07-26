import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class AdminUserController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
  }

  /**
   * @description This function adds a user to a group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async makeAdmin(req: AuthenticatedRequest<
    {
      targetId: string
      groupId: string
    },
    never,
    never
  >, res: express.Response, next: express.NextFunction): Promise<void> {
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
            req.statusCode = 409
            throw new Error('User is already an admin!')
          }
        })

      // Creates a new admin in the database
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
          req.statusCode = 500
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
  public async removeAdmin(req: AuthenticatedRequest< { targetId: string; groupId: string }, never, never >
    , res: express.Response, next: express.NextFunction): Promise<void> {
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
            req.statusCode = 409
            throw new Error('The user you are trying to remove is not an admin!')
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
          req.statusCode = 500
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
  public async kickUser(req: AuthenticatedRequest< { targetId: string; groupId: string }, never, never >
    , res: express.Response, next: express.NextFunction): Promise<void> {
    // Deletes the user from the groupMember table
    this.prisma.groupMember
      .deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })
      .then(() => {
        // Deletes the user from the admin table
        this.prisma.admin
          .deleteMany({
            where: {
              user_id: req.params.targetId,
              group_id: req.params.groupId,
            },
          })
          .catch((error) => {
            req.statusCode = 500
            next(new Error(error))
          })

        res.status(200).json({
          message: 'User kicked successfully!',
        })
      })
      .catch((error) => {
        req.statusCode = 500
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
        req.statusCode = 422
        next(new Error('User is already banned!'))
      }

      // Deletes the user from the groupMember table
      await this.prisma.groupMember.deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      // Deletes the user from the admin table
      await this.prisma.admin.deleteMany({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })

      // Creates a new banned user in the database
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
      req.statusCode = 500
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
  public async setCensored(req: AuthenticatedRequest< { groupId: string; recipeId: string }, never, {censored: boolean} >
    , res: express.Response, next: express.NextFunction): Promise<void> {
    try {
      // Find the author of the recipe
      const authorOfRecipe = await this.prisma.recipe.findFirst({
        where: {
          id: req.params.recipeId,
        },
      })

      // Check if recipe exists
      if (!authorOfRecipe) {
        req.statusCode = 422
        throw new Error('Recipe does not exist!')
      }

      // Check if recipe author is a member of the group
      await this.prisma.groupMember
        .findFirst({
          where: {
            user_id: authorOfRecipe.author_id,
          },
        })
        .then((result) => {
          if (!result) {
            req.statusCode = 409
            throw new Error('Recipe author is not a member of the group!')
          }
        })

        const censoredRecipeId = await this.prisma.censoredRecipe
        .findFirst({
          where: {
            recipe_id: req.params.recipeId,
            group_id: req.params.groupId,
          },
        })

        if (req.body.censored) {
          if (!censoredRecipeId) {
            await  this.prisma.censoredRecipe
            .create({
              data: {
                recipe_id: req.params.recipeId,
                group_id: req.params.groupId,
              },
            })
            res.status(200).json({
              message: 'Recipe censored successfully!',
            })
          } else {
            res.status(409).json({
              message: 'Recipe already censored',
            })
            return;
          }
        } else {
          if (censoredRecipeId) {
            await this.prisma.censoredRecipe.delete({
              where: {
                id: censoredRecipeId.id,
              },
            })
            res.status(200).json({
              message: 'Recipe uncensored successfully!',
            })
          } else {
            res.status(409).json({
              message: 'Recipe already uncensored',
            })
            return;
          }
        }
    } catch (error) {
      next(error)
    }
  }
}
