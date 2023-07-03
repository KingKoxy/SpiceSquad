import express = require("express");
import AbstractController from "./abstractController";
import schema from "../../../joi/schemas/groupMemberSchema";
import recipeSchema from "../../../joi/schemas/censoredRecipeSchema";

class AdminUserController extends AbstractController {
  constructor() {
    super();
  }

  //TODO: Add member check in middleware
  public async makeAdmin(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.admin
      .create({
        data: {
          user_id: req.body.target_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Admin created successfully!",
        });
      });
  }

  public async removeAdmin(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.admin
      .deleteMany({
        where: {
          user_id: req.body.target_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Admin removed successfully!",
        });
      });
  }

  public async kickUser(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.groupMember
      .deleteMany({
        where: {
          user_id: req.body.target_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "User kicked successfully!",
        });
      });
  }

  public async banUser(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.groupMember
      .deleteMany({
        where: {
          user_id: req.body.target_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {});

    this.prisma.bannedUser
      .create({
        data: {
          user_id: req.body.target_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "User banned successfully!",
        });
      });
  }

  public async setCensored(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = recipeSchema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.censoredRecipe
      .create({
        data: {
          recipe_id: req.body.recipe_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        console.log(result);
        res.status(200).json({
          message: "Recipe censored successfully!",
        });
      });
  }
}

export default AdminUserController;
