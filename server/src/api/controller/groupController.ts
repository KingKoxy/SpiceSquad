import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class GroupController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
  }

  /**
   * @description This function creates a new group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPost(
    req: AuthenticatedRequest<never, never, { groupName: string }>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const user = await this.prisma.user.findFirst({
      where: { id: req.userId },
    })
    if (user.created_groups >= parseInt(process.env.MAXIMUM_USER_GROUPS)) {
      req.statusCode = 409
      next(new Error('User has already created maximum number of groups'))
    }
    this.prisma.group
      .create({
        data: {
          name: req.body.groupName,
          Admin: {
            create: {
              user_id: req.userId,
            },
          },
          groupMember: {
            create: {
              user_id: req.userId,
            },
          },
        },
        include: { Admin: true, groupMember: true },
      })
      .then(() => {
        this.prisma.user
          .update({
            where: { id: req.userId },
            data: { created_groups: { increment: 1 } },
          })
          .then(() => {
            res.status(200).json({
              message: 'Group created successfully!',
            })
          })
          .catch((error) => {
            next(error)
          })
      })
  }

  /**
   * @description This function deletes a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupDelete(
    req: AuthenticatedRequest<
      {
        groupId: string
      },
      never,
      never
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.group
      .delete({
        where: {
          id: req.params.groupId,
        },
      })
      .then(() => {
        res.status(200).json({
          message: 'Deleted group!',
        })
      })
      .catch((error) => {
        req.statusCode = 500
        next(error)
      })
  }

  /**
   * @description This function updates a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPatch(
    req: AuthenticatedRequest<
      { groupId: string },
      never,
      {
        name: string
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.group
      .update({
        where: {
          id: req.params.groupId,
        },
        data: req.body.name || undefined,
      })
      .then(() => {
        res.status(200).json({
          message: 'Updated group!',
        })
      })
      .catch((error) => {
        req.statusCode = 500
        next(error)
      })
  }

  /**
   * @description This function allows to join a group by group code.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupJoin(
    req: AuthenticatedRequest<
      never,
      never,
      {
        groupCode: string 
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try {

      console.log(req.body.groupCode)

      const groupId =
        await this.prisma.group.findFirst({
          where: {
            group_code: req.body.groupCode,
          },
        }).then((result) => {
        if (result) {
          return result.id
        } else {
          req.statusCode = 404
          throw new Error('Group not found')
        }
      })

      await this.prisma.bannedUser
        .findFirst({
          where: {
            user_id: req.userId,
            group_id: groupId,
          },
        })
        .then((result) => {
          if (result) {
            req.statusCode = 403
            throw new Error('User is banned from this group')
          }
        })
      // Check if user is already in group
      await this.prisma.groupMember
        .findFirst({
          where: {
            user_id: req.userId,
            group_id: groupId,
          },
        })
        .then((result) => {
          if (result) {
            req.statusCode = 409
            throw new Error('User is already in this group')
          }
        })

      this.prisma.groupMember
        .create({
          data: {
            user_id: req.userId,
            group_id: groupId,
          },
        })
        .then(() => {
          res.status(200).json({
            message: 'Joined group!',
          })
        })
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function allows to leave a group by group id.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async groupLeave(
    req: AuthenticatedRequest<
      {
        groupId: string
      },
      never,
      never
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const groupMembers = await this.prisma.groupMember.findMany({
      where: {
        group_id: req.params.groupId,
        user_id: req.userId
      },
    })

    if (groupMembers.length == 0) {
      req.statusCode = 409
      next(new Error('Could not left group. User is not in this group'))
      
      
    } else if (groupMembers.length > 0) {
      await this.prisma.admin
        .deleteMany({
          where: {
            group_id: req.params.groupId,
            user_id: req.userId
          },
        })

      await (this.prisma.groupMember
        .deleteMany({
          where: {
            group_id: req.params.groupId,
            user_id: req.userId
          },
        })
        .then(async () => {
          if (await this.checkGroupEmpty(req.params.groupId)) {
          res.status(200).json({
            message: 'User was last member of group. User left group and group was deleted.',
          })
          } else {
            res.status(200).json({
              message: 'User left group.',
          })
          }
          
        })
        .catch((error) => {
          next((error.message = 'Group could not be left'))
        }))
    }
  
  }

  /**
   * @description This function gets all groups for a user.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupGetAllForUser(
    req: AuthenticatedRequest<never, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const groups = await Promise.all((await this.prisma.groupMember.findMany({
      where: {
        user_id: req.userId,
      },
    })).map(async (groupMember) => {
      return await this.getGroup(groupMember.group_id, req.userId)
    }))
    res.status(200).json({
      groups: groups
    })
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupGetById(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
      const group = await this.getGroup(req.params.groupId, req.body.userId)
      
      res.status(200).json({
        group
      })
  }
  /**
   * @description Gets all relevant information for a group by id
   * @param groupId 
   * @returns Promise<any>
   */
  private async getGroup(groupId: string, callerId: string) : Promise<any> {
    const groupDetails =  (await this.prisma.group
      .findUnique({
        where: {
          id: groupId
        },
      }))

      console.log("Diese Line wird erreicht")
      const members = await this.getGroupMembers(groupId)
      const admins = await this.getGroupAdmins(groupId)
      const users = (await this.prisma.user.findMany({
        where: {
          id: {
            in: members,
          },
        },
      }))

      const recipes = await this.getGroupRecipes(members)
      const censoredRecipes = await this.getGroupCensoredRecipes(groupId)
      var recipesWithCensor = await Promise.all((await this.prisma.recipe.findMany({
        where: {
          id: {
            in: recipes,
          }
        },
      })).map((async (recipe) => {
          const ingredients = await this.prisma.ingredient.findMany({
            where: {
              recipe_id: recipe.id
            }
          })
          return {
            recipe: {
              ...recipe,
              author: users.find((user) => user.id === recipe.author_id),
              ingredients: ingredients
            },
            is_censored: censoredRecipes.includes(recipe.id)
          }
        })))

      if ((await this.prisma.admin.findMany({
        where: {
          user_id: callerId,
          group_id: groupId
          }
          })).length == 0) {
            recipesWithCensor = recipesWithCensor.filter((recipe) => !recipe.is_censored)
          }


         const userAdmins = users.map((user) => {
          return{
            ...user,
            is_admin: admins.includes(user.id)
          }
        })

        return {
          id: groupDetails.id,
          name: groupDetails.name,
          group_code: groupDetails.group_code,
          members: userAdmins,
          recipes: recipesWithCensor
        }
  }  

  /**
 * @description This function gets all members of a group.
 * @param groupId The id of the group
 * @returns Promise<string[]>
 */
  private async getGroupMembers(groupId: string): Promise<string[]> {
    const groupMembers = await this.prisma.groupMember.findMany({
      where: {
        group_id: groupId,
      },
    })
    return groupMembers.map((groupMember) => groupMember.user_id)
  }

  /**
   * @description This function gets all admins of a group.
   * @param groupId The id of the group
   * @returns Promise<string[]>
   **/
  private async getGroupAdmins(groupId: string): Promise<string[]> {
    const groupAdmins = await this.prisma.admin.findMany({
      where: {
        group_id: groupId,
      },
    })
    return groupAdmins.map((groupAdmin) => groupAdmin.user_id)
  }

  /**
   * @description This function gets all recipes of a group.
   * @param groupId The id of the group
   * @returns Promise<string[]>
   * */
  private async getGroupRecipes(userIds : string[]): Promise<string[]> {
    const groupRecipes = await this.prisma.recipe.findMany({
      where: {
        author_id: {
          in: userIds,
        }
      },
    })
    return groupRecipes.map((groupRecipe) => groupRecipe.id)
  }

  /**
   * @description This function gets all censored recipes of a group.
   *  @param groupId The id of the group
   * @returns Promise<string[]>
   * */
  private async getGroupCensoredRecipes(groupId: string): Promise<string[]> {
    const groupCensoredRecipes = await this.prisma.censoredRecipe.findMany({
      where: {
        group_id: groupId,
      },
    })
    return groupCensoredRecipes.map((groupCensoredRecipe) => groupCensoredRecipe.recipe_id)
  }

  public async checkGroupEmpty(groupId : string) : Promise<boolean> {
    const groupMembers = await this.prisma.groupMember.findMany({
      where: {
        group_id: groupId,
      },
    })

    if (groupMembers.length == 0) {
      this.prisma.group
        .delete({
          where: {
            id: groupId,
          },
        })
        .then(() => {
          console.log('Group was empty and was deleted')
          return true
        })
        .catch((error) => {
          console.log('Group was empty but could not be deleted')
        })
    }

    await (this.prisma.admin.findMany({
      where: {
        group_id: groupId,
      },
    }).then((admins) => {
      console.log(admins)
      if (admins.length == 0) {
        this.prisma.groupMember.findMany({
          where: {
            group_id: groupId,
          },
          orderBy: {
            joined_at: 'asc',
          },
        }).then((groupMembers) => {
          this.prisma.admin
            .create({
              data: {
                user_id: groupMembers[0].user_id,
                group_id: groupId,
              },
            })
            .then(() => {
              console.log('Longest group member is now admin.')
            })
            .catch((error) => {
              console.log('Could not make longest group member admin.')
            })
        })
      }
    }))

    return false
  }
}


