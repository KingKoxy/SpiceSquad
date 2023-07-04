import express = require("express");
import AbstractController from "./abstractController";
import mailSender from "../../mailer/mailSender";
import reportMailBuilder from "../../mailer/mailBuilder/reportMailBuilder";
import schema from "../../../joi/schemas/recipeSchema";

class RecipeController extends AbstractController {
  private mailSender: mailSender;
  private reportMailBuilder: reportMailBuilder;

  constructor() {
    super();
    this.mailSender = new mailSender();
    this.reportMailBuilder = new reportMailBuilder();
  }

  public async recipePost(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }
    await this.prisma.recipe
      .create({
        data: {
          title: req.body.title,
          author_id: req.body.user_id,
          image: Buffer.from(req.body.image, "base64"),
          duration: parseInt(req.body.duration),
          difficulty: req.body.difficulty.toUpperCase(),
          instructions: req.body.instructions,
          is_vegetarian: req.body.is_vegetarian,
          is_vegan: req.body.is_vegan,
          is_gluten_free: req.body.is_gluten_free,
          is_kosher: req.body.is_kosher,
          is_halal: req.body.is_halal,
          is_private: req.body.is_private,
          default_portions: parseInt(req.body.default_portions),
          ingredient: {
            createMany: {
              data: req.body.ingredients.map((ingredient: any) => {
                return {
                  name: ingredient.name,
                  icon_name: ingredient.icon_name,
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

  public async recipeDelete(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const requireParams = ["recipe_id"];
    const missingParams = requireParams.filter((param) => !(param in req.body));
    if (missingParams.length > 0) {
      res.status(400).json({
        error: "Missing parameters: " + missingParams.join(", "),
      });
      return;
    }
    console.log(req.body.recipe_id);
    await this.prisma.recipe
      .delete({
        where: {
          id: req.body.recipe_id,
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

  public async recipePatch(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const requireParams = [
      "recipe_id",
      "user_id",
      "title",
      "image",
      "duration",
      "difficulty",
      "instructions",
      "is_vegetarian",
      "is_vegan",
      "is_gluten_free",
      "is_kosher",
      "is_halal",
      "is_private",
      "default_portions",
    ];
    const missingParams = requireParams.filter((param) => !(param in req.body));
    if (missingParams.length > 0) {
      res.status(400).json({
        error: "Missing parameters: " + missingParams.join(", "),
      });
      return;
    }
    //const result = await this.pool.query('SELECT author_id FROM "recipe" WHERE id = $1',[req.body.recipe_id]);
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
          title: req.body.title,
          image: Buffer.from(req.body.image, "base64"),
          duration: parseInt(req.body.duration),
          difficulty: req.body.difficulty.toUpperCase(),
          instructions: req.body.instructions,
          is_vegetarian: req.body.is_vegetarian,
          is_vegan: req.body.is_vegan,
          is_gluten_free: req.body.is_gluten_free,
          is_kosher: req.body.is_kosher,
          is_halal: req.body.is_halal,
          is_private: req.body.is_private,
          default_portions: parseInt(req.body.default_portions),
        },
      })
      .then((result) => {
        for (const ingredient of req.body.ingredients) {
          const requireParams = ["name", "icon_name", "amount", "unit"];
          const missingParams = requireParams.filter(
            (param) => !(param in ingredient)
          );
          if (missingParams.length > 0) {
            res.status(400).json({
              error: "Missing parameters: " + missingParams.join(", "),
            });
            return;
          }
          this.prisma.ingredient.update({
            where: {
              id: ingredient.id,
            },
            data: {
              name: ingredient.name,
              icon_name: ingredient.icon_name,
              amount: ingredient.amount,
              unit: ingredient.unit,
            },
          });
        }
        res.status(200).json({
          message: "Recipe updated successfully!",
        });
      });
  }

  public async recipesGetAllForUser(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    // Get all recipes for user from DB where user is author
    this.prisma.recipe
      .findMany({
        where: {
          author_id: req.body.userId,
        },
      })
      .then((result) => {
        console.log(result);
        res.status(200).json({
          recipes: result,
        });
      });
    //Get all recipes for user from DB where user groupmember and recipe is not private and recipe is not censorred
  }

  public async recipeReport(
    req: express.Request,
    res: express.Response
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

  public async recipeSetFavorite(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const requireParams = ["user_id", "is_favorite"];
    const missingParams = requireParams.filter((param) => !(param in req.body));
    if (missingParams.length > 0) {
      res.status(400).json({
        error: "Missing parameters2: " + missingParams.join(", "),
      });
      return;
    }

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
          //delete recipe from favorites table where recipe_id = req.params.productId and user_id = req.body.user_id
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
        res.status(500).json({
          error: error,
        });
      });
  }
}

export default RecipeController;
