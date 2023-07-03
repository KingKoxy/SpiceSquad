import express = require("express");
import AbstractController from "./abstractController";
import schema from "../../../joi/schemas/groupSchema";
import memberSchema from "../../../joi/schemas/groupMemberSchema";

class GroupController extends AbstractController {
  constructor() {
    super();
  }

  public async groupPost(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = schema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }

    this.prisma.group
      .create({
        data: {
          name: req.body.name,
          admin: {
            create: {
              user_id: req.body.user_id,
            },
          },
          groupMember: {
            create: {
              user_id: req.body.user_id,
            },
          },
        },
        include: { admin: true, groupMember: true },
      })
      .then((result) => {
        res.status(200).json({
          message: "Group created successfully!",
        });
      });
  }

  public async groupDelete(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    await this.prisma.group
      .delete({
        where: {
          id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Deleted group!",
        });
      });
  }

  public async groupPatch(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    this.prisma.group
      .update({
        where: {
          id: req.body.group_id,
        },
        data: {
          name: req.body.name,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Updated group!",
        });
      });
  }

  public async groupJoin(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = memberSchema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }
    this.prisma.groupMember
      .create({
        data: {
          user_id: req.body.user_id,
          group_id: req.body.group_id,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Joined group!",
        });
      });
  }

  public async groupLeave(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    const { error, value } = memberSchema.validate(req.body);
    if (error) {
      res.status(422).json({ error: error.details[0].message });
      return;
    }
    this.prisma.groupMember.deleteMany({
      where: {
        user_id: req.body.user_id,
        group_id: req.body.group_id,
      },
    });

    res.status(200).json({
      message: "Left group!",
    });
  }

  public async groupGetAllForUser(
    req: express.Request,
    res: express.Response
  ): Promise<void> {
    this.prisma.group
      .findMany({
        where: {
          groupMember: {
            some: {
              user_id: req.body.user_id,
            },
          },
        },
      })
      .then((result) => {
        console.log(result);
        res.status(200).json(result);
      });
  }
}

export default GroupController;
