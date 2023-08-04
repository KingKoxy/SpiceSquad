import express = require('express')
import AbstractController from './abstractController'
import MailSender from '../../mailer/mailSender'
import ReportMailBuilder from '../../mailer/mailBuilder/reportMailBuilder'
import AuthenticatedRequest from '../middleware/authenticatedRequest'
import ImageController from './imageController'
import IngredientController from './ingredientController'

export default class RecipeController extends AbstractController {
  /**
   * @description This variable contains the mailSender.
   * @private
   * @type {mailSender}
   */
  private mailSender: MailSender

  private ingredientController: IngredientController
  /**
   * @description This variable contains the reportMailBuilder.
   * @private
   * @type {reportMailBuilder}
   */
  private reportMailBuilder: ReportMailBuilder


  /**
   * @description This variable contains the imageController.
   * @private
   * @type {imageController}
   */
  private ImageController;

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
    this.ImageController = new ImageController()
    this.mailSender = new MailSender()
    this.reportMailBuilder = new ReportMailBuilder()
    this.ingredientController = new IngredientController()
  }

  /**
   * @description This function posts a recipe.
   * @param req AuthenticatedRequest<never,never,{title: string, image: Uint8Array | null, duration: number, difficulty: 'EASY' | 'MEDIUM' | 'HARD', instructions: string, isVegetarian: boolean, isVegan: boolean, isGlutenFree: boolean, isKosher: boolean, isHalal: boolean, defaultPortionAmount: number, ingredients: {name: string, icon: Uint8Array, amount: number, unit: string}[]}
   * @param res Express response containing message
   * @returns Promise<void>
   */
  public async recipePost(
    req: AuthenticatedRequest<
      never,
      never,
      {
        title: string
        image: string
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
          icon: string
          amount: number
          unit: string
        }[]
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const imageId = req.body.image? await this.ImageController.createImage(req.body.image):null;
    await this.prisma.recipe
      .create({
        data: {
          title: req.body.title,
          author_id: req.userId,
          image: imageId,
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
                  icon: this.ingredientController.fromURLtoId(ingredient.icon),
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
        req.statusCode = 400 // TODO change
        next(error)
      })
  }

  /**
   * @description This function gets a recipe by id.
   * @param req AuthenticatedRequest<{recipeId: string},never,never> containing recipeId in head
   * @param res Express response containing message
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
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const recipe = await this.prisma.recipe
      .findUnique({
        where: {
          id: req.params.recipeId,
        },
      })
      if (!recipe) {
          res.status(409).json({
            message: 'Recipe not found',
          })
        }
      else if (recipe.author_id !== req.userId) {
        res.status(401).json({
          message: 'Not your recipe',
        })
      } else {
        const deletedRecipe = await this.prisma.recipe
          .delete({
            where: {
               id: req.params.recipeId,
            },
          })
        console.log(deletedRecipe.image)
          this.prisma.image.delete({
            where: {
              id: deletedRecipe.image,
            },
          }).then(() => {
            res.status(200).json({
               message: 'Recipe deleted successfully!',
            })
          })
          .catch((error) => {
          res.statusCode = 409
           next(error)
       })
      }
  }

  /**
   * @description This function changes a recipe by id.
   * @param req AuthenticatedRequest<{recipeId: string},never,{title: string, image: Uint8Array | null, duration: number, difficulty: 'EASY' | 'MEDIUM' | 'HARD', instructions: string, isVegetarian: boolean, isVegan: boolean, isGlutenFree: boolean, isKosher: boolean, isHalal: boolean, isPrivate: boolean, defaultPortionAmount: number, ingredients: {id: string, name: string, icon: Uint8Array, amount: number, unit: string}[]}> containing recipeId in head
   * @param res Express response containing message
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipePatch(
    req: AuthenticatedRequest<
      { recipeId },
      never,
      {
        title: string;
        image: string;
        duration: number;
        difficulty: 'EASY' | 'MEDIUM' | 'HARD';
        instructions: string;
        isVegetarian: boolean;
        isVegan: boolean;
        isGlutenFree: boolean;
        isKosher: boolean;
        isHalal: boolean;
        isPrivate: boolean;
        defaultPortionAmount: number;
        ingredients: {
          id: string;
          name: string;
          icon: string;
          amount: number;
          unit: string;
        }[];
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const recipe = await this.prisma.recipe.findUnique({
      where: {
        id: req.params.recipeId,
      },
      include: {
        ingredient: true,
      },
    });
  
    if (req.userId !== recipe.author_id) {
      res.status(401).json({
        error: 'You are not authorized to edit this recipe!',
      });
      return;
    }

    if (req.body.image == '' && recipe.image != null) {
      this.ImageController.deleteImage(recipe.image);
    }
    const imageId = req.body.image?this.ImageController.fromURLtoId(req.body.image):null

    req.body.ingredients.forEach((ingredient) => {
      if (!ingredient.id || ingredient.id === "") {
        ingredient.id = "00000000-0000-0000-0000-000000000000";
      }
    });

    try {
      // Update recipe information
      await this.prisma.recipe.update({
        where: {
          id: req.params.recipeId,
        },
        data: {
          title: req.body.title,
          image: imageId,
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
            upsert: req.body.ingredients.map((ingredient) => ({
              where: { id: ingredient.id },
              update: {
                name: ingredient.name,
                icon: this.ingredientController.fromURLtoId(ingredient.icon),
                amount: ingredient.amount,
                unit: ingredient.unit,
              },
              create: {
                name: ingredient.name,
                icon: this.ingredientController.fromURLtoId(ingredient.icon),
                amount: ingredient.amount,
                unit: ingredient.unit,
              },
            })),
          },
        },
        include: {
          ingredient: true,
        },
      });

      res.status(200).json({
        message: 'Recipe updated successfully!',
      });
    } catch (error) {
      req.statusCode = 409;
      console.log(error);
      next(error)
    }
  }

  /**
   * @description This function gets all recipes for a user.
   * @param req AuthenticatedRequest<never,never,never>
   * @param res Express response containing all non-censored, non-private recipes for groups the user is in as well as all of his own recipes
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

      if (groupIds.length === 0) {
        const recipes = await this.prisma.recipe.findMany({
          where: {
            author_id: req.userId,
          },
        })

        // Find all favorites of the user
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
            const ingredients = await this.prisma.ingredient.findMany({
              where: {
                recipe_id: recipe.id,
              },
            })

            ingredients.forEach((ingredient) => {
              ingredient.icon = this.ingredientController.fromIdtoURL(ingredient.icon)
            })

            // Change date format so that that is only the date and not the time
            const recipeWithDate = {...recipe, upload_date: recipe.upload_date.toISOString(), image: recipe.image?this.ImageController.fromIdtoURL(recipe.image):""}
            delete recipeWithDate.author_id

            return {
              ...recipeWithDate,
              author: author,
              ingredients,
              isFavourite: favouriteIds.includes(recipe.id),
            }
          })
        )

        // Send the response with the user's recipes
        res.status(200).json(recipesWithAuthorAndFavourite)
      } else {
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

        // Find all favourite recipes for the user
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
            const ingredients = await this.prisma.ingredient.findMany({
              where: {
                recipe_id: recipe.id,
              },
            })

            const recipeWithDate = {...recipe, upload_date: recipe.upload_date.toISOString(), image: recipe.image?this.ImageController.fromIdtoURL(recipe.image):""}
            delete recipeWithDate.author_id
            
           return {
              ...recipeWithDate,
              author: author,
              ingredients,
              isFavourite: favouriteIds.includes(recipe.id),
            }
          })
        )

        // Return recipes with author and isFavourite
        res.status(200).json(recipesWithAuthorAndFavourite)
      }
    } catch (e) {
      res.status(500).json({
        error: e,
      })
    }
  }

  /**
   * @description This function sends a report mail to all admins that are in a group containing this recipe
   * @param req AuthenticatedRequest<{recipeId: string}, never, never>
   * @param res Express response containing message
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
    //get recipe title
    const recipe = await this.prisma.recipe.findUnique({
      where: {
        id: req.params.recipeId,
      },
    })
    const recipeTitle = recipe.title;

    //check if entry is older than 24 hours
    const reportedRecipe = await this.prisma.reportedRecipe.findFirst({
      where: {
        recipe_id: req.params.recipeId,
        user_id: req.userId,
      },
    })
    if (reportedRecipe && reportedRecipe.reported_at > new Date(Date.now() - 24 * 60 * 60 * 1000)) {
      res.status(429).json({
        message: 'Recipe already reported within the last 24 hours',
      })
      return;
    } else if (reportedRecipe) {
      await this.prisma.reportedRecipe.delete({
        where: {
          id: reportedRecipe.id,
        },
      })
    }

    //create entry in reported recipe table
    await this.prisma.reportedRecipe.create({
      data: {
        recipe_id: req.params.recipeId,
        user_id: req.userId,
      },
    })


    //get all admins where the recipe is in their group
    const recipeAuthorId = (
      await this.prisma.recipe.findUnique({
        where: {
          id: req.params.recipeId,
        },
      })
    ).author_id

    //get user from recipe author id
    const recipeAuthor = ( await this.prisma.user.findUnique({
      where: {
        id: recipeAuthorId,
      },
    }))
    const recipeAuthorName = recipeAuthor.user_name;

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
    )
    for (const adminEmail of adminEmails) {
      this.mailSender.sendMail(this.reportMailBuilder.buildMail(adminEmail.email, adminEmail.user_name ,recipeTitle, recipeAuthorName))
    }

    res.status(200).json({
      message: 'Recipe reported successfully!',
    })
  }

  /**
   * @description This function changes the favorite status of the recipe.
   * @param req AuthenticatedRequest<{recipeId: string}, never, {isFavorite: boolean}> 
   * @param res Express response containing message
   * @returns Promise<void>
   */
  public async recipeSetFavorite(
    req: AuthenticatedRequest<{ recipeId: string }, never, { isFavorite: boolean }>,
    res: express.Response
  ): Promise<void> {
    //check if recipe exists
    const recipe = await this.prisma.recipe.findUnique({
      where: {
        id: req.params.recipeId,
      },
    })
    if (!recipe) {
      res.status(409).json({
        message: 'Recipe not found',
      })
      return;
    }

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

    if (req.body.isFavorite) {
      if (!favouriteId) {
        await this.prisma.favorite.create({
          data: {
            recipe_id: req.params.recipeId,
            user_id: req.userId,
          },
        })
        res.status(200).json({
          message: 'Recipe favourite set successfully!',
        })
      } else {
        res.status(409).json({
          message: 'Recipe already favored',
        })
        return;
      }
    } else {
      if (favouriteId) {
        await this.prisma.favorite.delete({
          where: {
            id: favouriteId.id,
          },
        })
        res.status(200).json({
          message: 'Recipe favourite removed successfully!',
        })
      } else {
        res.status(409).json({
          message: 'Recipe not found in favorites',
        })
        return;
      }
    }
  }

}
