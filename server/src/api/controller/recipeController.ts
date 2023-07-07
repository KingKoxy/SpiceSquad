import express = require("express");
import AbstractController from "./abstractController";
import mailSender from "../../mailer/mailSender";
import reportMailBuilder from "../../mailer/mailBuilder/reportMailBuilder";

/**
 * @description This class contains the controller for the recipe router.
 * @class RecipeRouter
 * @extends abstractRouter
 * @exports RecipeRouter
 * @version 1.0.0
 * @requires RecipeController
 * @requires express
 * @requires AbstractController
 * @requires mailSender
 * @requires reportMailBuilder
 */
export default class RecipeController extends AbstractController {

  
  /**
   * @description This variable contains the mailSender.
   * @private
   * @type {mailSender}
   */
  private mailSender: mailSender;

  /**
   * @description This variable contains the reportMailBuilder.
   * @private
   * @type {reportMailBuilder}
   */
  private reportMailBuilder: reportMailBuilder;

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void
   */
  constructor() {
    super();
    this.mailSender = new mailSender();
    this.reportMailBuilder = new reportMailBuilder();
  }

  /**
   * @description This function gets all recipes.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipePost(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.recipe
      .create({
        data: {
          title: req.body.title,
          author_id: req.body.userId,
          image: Buffer.from(req.body.image, "base64") ,
          duration: parseInt(req.body.duration),
          difficulty: req.body.difficulty.toUpperCase(),
          instructions: req.body.instructions,
          is_vegetarian: req.body.isVegetarian,
          is_vegan: req.body.isVegan,
          is_gluten_free: req.body.isGlutenFree,
          is_kosher: req.body.isKosher,
          is_halal: req.body.isHalal,
          is_private: req.body.isPrivate,
          default_portions: parseInt(req.body.defaultPortions),
          ingredient: {
            createMany: {
              data: req.body.ingredients.map((ingredient: any) => {
                return {
                  name: ingredient.name,
                  icon_name: ingredient.iconName,
                  amount: parseInt(ingredient.amount),
                  unit: ingredient.unit,
                };
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
          message: "Recipe created successfully!",
        });
      })
      .catch((error) => {
        res.status(500).json({
          error: error,
        });
      });

  }

  /**
   * @dexcription This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipeDelete(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    if (req.body.userId != req.body.author_id) {
      res.statusCode = 401;
        next(new Error("You are not authorized to delete this recipe!"));
      };
    await this.prisma.recipe
      .delete({
        where: {
          id: req.params.id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Recipe deleted successfully!",
        });
      })
      .catch((error) => {
        res.status(500).json({
          error: error,
        });
      });
  }

  /**
   * @description This function changes a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipePatch(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const author = await this.prisma.recipe.findUnique({
      where: {
        id: req.body.recipe_id,
      },
    })
    if (req.body.user_id != author.author_id) {
      res.status(401).json({
        error: "You are not authorized to edit this recipe!",
      });
      return;
    }

      this.prisma.recipe.update({
        where: {
          id: req.body.recipe_id,
        },
        data: {
          title: req.body.title || undefined,
          image: Buffer.from(req.body.image, "base64") || undefined,
          duration: parseInt(req.body.duration) || undefined,
          difficulty: req.body.difficulty.toUpperCase() || undefined,
          instructions: req.body.instructions || undefined,
          is_vegetarian: req.body.isVegetarian || undefined,
          is_vegan: req.body.isVegan || undefined,
          is_gluten_free: req.body.isGlutenFree || undefined,
          is_kosher: req.body.isKosher || undefined,
          is_halal: req.body.isHalal || undefined,
          is_private: req.body.isPrivate || undefined,
          default_portions: parseInt(req.body.defaultPortions) || undefined,
          ingredient: {
            createMany: {
              data: req.body.ingredients.map((ingredient: any) => {
                return {
                  name: ingredient.name,
                  icon_name: ingredient.iconName,
                  amount: parseInt(ingredient.amount),
                  unit: ingredient.unit,
                };
              }),
          },
        },
      },
        include: {
          ingredient: true,
        }})
      .then((result) => {
        res.status(200).json({
          message: "Recipe updated successfully!",
        });
      })
      .catch((error) => {
        req.statusCode = 409;
        next(error);
        });
      }

  /**
   * @description This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipesGetAllForUser(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    // Get all recipes for user from DB where user is author

    this.prisma.groupMember.findMany({
      where: {
        user_id: req.body.userId,
      },

    }).then((result) => {
      var groups: Set<string> = new Set();
      for (var a of result) {
        groups.add(a.group_id);
      }
      let groupArray = Array.from(groups);
      this.prisma.groupMember.findMany({
        where: {
          group_id: {
            in: groupArray
          }
        }
      }).then((result) => {
      var allusers: Set<string> = new Set();
      for (var a of result) {
        allusers.add(a.user_id);
      }
      let userArray = Array.from(allusers);
      
      this.prisma.recipe.findMany({
        where: {
          author_id: {
            in: userArray
          },
          is_private: false
        }
      }).then((result) => {
        var recipes: Map<string,string> = new Map();
        for (var a of result) {
          recipes.set(a.id, a.author_id);
        }
        let recipeArray = Array.from(recipes.keys());
        this.prisma.censoredRecipe.findMany({
          where: {
            recipe_id: {
              in: recipeArray
            }
          }
        }).then((result) => {
          var censoredRecipes: Set<string> = new Set();
          for (var a of result) { 
            censoredRecipes.add(a.recipe_id);
          }
          
        })
      })
    })
    })

    //Get all recipes for user from DB where user groupmember and recipe is not private and recipe is not censorred
  }

  /**
   * @description This function gets a recipe by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipeReport(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    //get all admins where recipe is in group of admin
    const author = await this.prisma.recipe.findUnique({
      where: {
        id: req.params.productId,
      },
      include: {
        Author: true,
      },
    });
    let author_id: String;
    if (author) {
      author_id = author.Author.id;
    }
    const admin = await this.prisma.group.findMany({
      where: {
        groupMember: {
          some: {
            user_id: req.body.author_id,
          },
        },
      },
    });
    console.log(admin);

    res.status(200).json({
      message: "Recipe reported successfully!",
    });
  }

  /**
   * @description This function changes the favorite status of recipe.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async recipeSetFavorite(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.favorite
      .count({
        where: {
          recipe_id: req.params.productId,
        },
      })
      .then((result) => {
        if (req.body.is_favorite && result == 0) {
          this.prisma.favorite
            .create({
              data: {
                user_id: req.body.user_id,
                recipe_id: req.params.productId,
              },
            })
            .then((result) => {
              res.status(200).json({
                message: "Recipe set as favorite successfully!",
              });
            })
            .catch((error) => {
              res.status(500).json({
                error: error,
              });
            });
        } else if (!req.body.is_favorite && result > 0) {
          this.prisma.favorite
            .deleteMany({
              where: {
                recipe_id: req.params.productId,
                user_id: req.body.user_id,
              },
            })
            .then((result) => {
              res.status(200).json({
                message: "Recipe removed from favorites successfully!",
              });
            })
            .catch((error) => {
              res.status(500).json({
                error: error,
              });
            });
        } else if (!req.body.is_favorite && result == 0) {
          res.status(200).json({
            message: "Recipe already not in favorites!",
          });
        } else {
          res.status(200).json({
            message: "Recipe already in favorites!",
          });
        }
      })
      .catch((error) => {
        req.statusCode = 409;
          next(error);
        });
  }
}
