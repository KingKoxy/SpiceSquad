import express = require('express')
import AbstractController from './abstractController'
import MailSender from '../../mailer/mailSender'
import ReportMailBuilder from '../../mailer/mailBuilder/reportMailBuilder'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class RecipeController extends AbstractController {
  /**
   * @description This variable contains the mailSender.
   * @private
   * @type {mailSender}
   */
  private mailSender: MailSender

  /**
   * @description This variable contains the reportMailBuilder.
   * @private
   * @type {reportMailBuilder}
   */
  private reportMailBuilder: ReportMailBuilder

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
    this.mailSender = new MailSender()
    this.reportMailBuilder = new ReportMailBuilder()
  }

  /**
   * @description This function gets all recipes.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async recipePost(
    req: AuthenticatedRequest<
      never,
      never,
      {
        title: string
        image: Uint8Array
        duration: number
        difficulty: 'EASY' | 'MEDIUM' | 'HARD'
        instructions: string
        isVegetarian: boolean
        isVegan: boolean
        isGlutenFree: boolean
        isKosher: boolean
        isHalal: boolean
        defaultPortionAmount: number
        ingredients: {
          name: string
          icon: Uint8Array
          amount: number
          unit: string
        }[]
      }
    >,
    res: express.Response
  ): Promise<void> {
    await this.prisma.recipe
      .create({
        data: {
          title: req.body.title,
          author_id: req.userId,
          image: Buffer.from(req.body.image),
          duration: req.body.duration,
          difficulty: req.body.difficulty,
          instructions: req.body.instructions,
          is_vegetarian: req.body.isVegetarian,
          is_vegan: req.body.isVegan,
          is_gluten_free: req.body.isGlutenFree,
          is_kosher: req.body.isKosher,
          is_halal: req.body.isHalal,
          is_private: false,
          default_portions: req.body.defaultPortionAmount,
          ingredient: {
            createMany: {
              data: req.body.ingredients.map((ingredient) => {
                return {
                  name: ingredient.name,
                  icon: Buffer.from(ingredient.icon),
                  amount: ingredient.amount,
                  unit: ingredient.unit,
                }
              }),
            },
          },
        },
        include: {
          ingredient: true,
        },
      })
      .then(() => {
        res.status(200).json({
          message: 'Recipe created successfully!',
        })
      })
      .catch((error) => {
        res.status(500).json({
          error: error,
        })
      })
  }

  /**
   * @description This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async recipeDelete(
    req: AuthenticatedRequest<
      {
        recipeId: string
      },
      never,
      never
    >,
    res: express.Response
  ): Promise<void> {
    await this.prisma.recipe
      .findUnique({
        where: {
          id: req.params.recipeId,
        },
      })
      .then((result) => {
        if (result.author_id !== req.userId) {
          res.status(401).json({
            message: 'Not your recipe',
          })
        } else {
          this.prisma.recipe
            .delete({
              where: {
                id: req.params.recipeId,
              },
            })
            .then(() => {
              res.status(200).json({
                message: 'Recipe deleted successfully!',
              })
            })
        }
      })
      .catch((error) => {
        res.status(500).json({
          error: error,
        })
      })
  }

  /**
   * @description This function changes a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipePatch(
    req: AuthenticatedRequest<
      { recipeId },
      never,
      {
        title: string
        image: Uint8Array
        duration: number
        difficulty: 'EASY' | 'MEDIUM' | 'HARD'
        instructions: string
        isVegetarian: boolean
        isVegan: boolean
        isGlutenFree: boolean
        isKosher: boolean
        isHalal: boolean
        isPrivate: boolean
        defaultPortionAmount: number
        ingredients: {
          name: string
          icon: Uint8Array
          amount: number
          unit: string
        }[]
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const recipe = await this.prisma.recipe.findUnique({
      where: {
        id: req.params.recipeId,
      },
    })
    if (req.userId != recipe.author_id) {
      res.status(401).json({
        error: 'You are not authorized to edit this recipe!',
      })
      return
    }

    this.prisma.recipe
      .update({
        where: {
          id: req.params.recipeId,
        },
        data: {
          title: req.body.title,
          image: Buffer.from(req.body.image),
          duration: req.body.duration,
          difficulty: req.body.difficulty,
          instructions: req.body.instructions,
          is_vegetarian: req.body.isVegetarian,
          is_vegan: req.body.isVegan,
          is_gluten_free: req.body.isGlutenFree,
          is_kosher: req.body.isKosher,
          is_halal: req.body.isHalal,
          is_private: req.body.isPrivate,
          default_portions: req.body.defaultPortionAmount,
          ingredient: {
            createMany: {
              data: req.body.ingredients.map((ingredient) => {
                return {
                  name: ingredient.name,
                  icon: Buffer.from(ingredient.icon),
                  amount: ingredient.amount,
                  unit: ingredient.unit,
                }
              }),
            },
          },
        },
        include: {
          ingredient: true,
        },
      })
      .then(() => {
        res.status(200).json({
          message: 'Recipe updated successfully!',
        })
      })
      .catch((error) => {
        req.statusCode = 409
        next(error)
      })
  }

  /**
   * @description This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async recipesGetAllForUser(
    req: AuthenticatedRequest<never, never, never>,
    res: express.Response
  ): Promise<void> {
    try {
      // Find all groups the user is a member of
      const groupIds = (
        await this.prisma.groupMember.findMany({
          where: {
            user_id: req.userId,
          },
        })
      ).map((groupMember) => groupMember.group_id)

      // Find all members of the groups
      const memberIds = (
        await this.prisma.groupMember.findMany({
          where: {
            group_id: {
              in: groupIds,
            },
          },
        })
      ).map((groupMember) => groupMember.user_id)

      // Find all censored recipes of the groups
      const censoredRecipeIds = (
        await this.prisma.censoredRecipe.findMany({
          where: {
            group_id: {
              in: groupIds,
            },
          },
        })
      ).map((censoredRecipe) => censoredRecipe.recipe_id)

      // Find all recipes of the members that are not censored or private (unless by the user)
      const recipes = await this.prisma.recipe.findMany({
        where: {
          author_id: {
            in: memberIds,
          },
          OR: [
            { author_id: req.userId },
            {
              is_private: false,
              id: {
                notIn: censoredRecipeIds,
              },
            },
          ],
        },
      })

      // Find all favourites of the user
      const favouriteIds = (
        await this.prisma.favorite.findMany({
          where: {
            user_id: req.userId,
          },
        })
      ).map((favourite) => favourite.recipe_id)

      //Get all recipes with author from author_id
      const recipesWithAuthorAndFavourite = await Promise.all(
        recipes.map(async (recipe) => {
          const author = await this.prisma.user.findUnique({
            where: {
              id: recipe.author_id,
            },
          })
          return {
            ...recipe,
            author,
            isFavourite: favouriteIds.includes(recipe.id),
          }
        })
      )

      // Return recipes with author and isFavourite
      res.status(200).json(recipesWithAuthorAndFavourite)
    } catch (e) {
      res.status(500).json({
        error: e,
      })
    }
  }

  /**
   * @description This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async recipeReport(
    req: AuthenticatedRequest<
      {
        recipeId: string
      },
      never,
      never
    >,
    res: express.Response
  ): Promise<void> {
    //get all admins where the recipe is in their group
    const recipeAuthorId = (
      await this.prisma.recipe.findUnique({
        where: {
          id: req.params.recipeId,
        },
      })
    ).author_id

    const groupIds = (
      await this.prisma.groupMember.findMany({
        where: {
          user_id: recipeAuthorId,
        },
      })
    ).map((groupMember) => groupMember.group_id)

    const adminIds = (
      await this.prisma.admin.findMany({
        where: {
          group_id: {
            in: groupIds,
          },
        },
      })
    ).map((admin) => admin.user_id)

    const adminEmails = (
      await this.prisma.user.findMany({
        where: {
          id: {
            in: adminIds,
          },
        },
      })
    ).map((user) => user.email)

    // TODO: Send notification to admins
    for (const adminEmail of adminEmails) {
      //this.mailSender.sendMail();
    }

    res.status(200).json({
      message: 'Recipe reported successfully!',
    })
  }

  /**
   * @description This function changes the favorite status of the recipe.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async recipeSetFavorite(
    req: AuthenticatedRequest<{ recipeId: string }, never, { value: boolean }>,
    res: express.Response
  ): Promise<void> {
    const favouriteId = await this.prisma.favorite.findFirst({
      where: {
        recipe_id: {
          equals: req.params.recipeId,
        },
        user_id: {
          equals: req.userId,
        },
      },
    })
    if (req.body.value) {
      if (!favouriteId) {
        await this.prisma.favorite.create({
          data: {
            recipe_id: req.params.recipeId,
            user_id: req.userId,
          },
        })
      } else {
        res.status(409).json({
          message: 'Recipe already favored',
        })
      }
    } else {
      if (favouriteId) {
        await this.prisma.favorite.delete({
          where: {
            id: favouriteId.id,
          },
        })
      } else {
        res.status(409).json({
          message: 'Recipe not favored',
        })
      }
    }
    res.status(200).json({
      message: 'Recipe favourite set successfully!',
    })
  }
}
