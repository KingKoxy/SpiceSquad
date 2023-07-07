import express = require("express");
import AbstractController from "./abstractController";


/**
 * @description This class contains the controller for the group router.
 * @class GroupRouter
 * @extends abstractRouter
 * @exports GroupRouter
 * @version 1.0.0
 * @requires GroupController
 * @requires express
 * @requires AbstractController
 * 
 */
export default class GroupController extends AbstractController {

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void
   */
  constructor() {
    super();
  }

  /**
   * @description This function creates a new group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPost(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const result = await this.prisma.user.findFirst({
      where: {id : req.body.user_id}
    })

      
      if(result.created_groups > 9) {
        console.log(result.created_groups)
        next(new Error("User has already created maximum number of groups"));
        return;
      }
    this.prisma.group
      .create({
        data: {
          name: req.body.groupName,
          Admin: { 
            create: {
              user_id: req.body.userId,
            },
          },
          groupMember: { 
            create: {
              user_id: req.body.userId,
            },
          },
        },
        include: { Admin: true, groupMember: true },
      })
      .then((result) => {
        this.prisma.user.update({
          where: {id : req.body.userId},
          data: {created_groups : {increment : 1}}
        }).then((result) => {
        res.status(200).json({
          message: "Group created successfully!",
        });
      })
      .catch((error) => {
        req.statusCode = 422;
        next(error);
      });
      });
    }

  /**
   * @description This function deletes a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupDelete(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.group
      .delete({
        where: {
          id: req.params.groupId,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Deleted group!",
        });
      }).catch((error) => {
        req.statusCode = 422;
        next(error);
      });
  }

  /**
   * @description This function updates a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPatch(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.group
      .update({
        where: {
          id: req.body.groupId,
        },
        data: {
          name: req.body.name,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Updated group!",
        });
      }).catch((error) => {
        req.statusCode = 422;
        next(error);
      });
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupJoin(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try{
    const result = await this.prisma.bannedUser.findMany({
      where : {
        user_id : req.body.userId,
        group_id : req.body.groupId
      }

    });
      if (result.length > 0) {
        res.status(403).json({
          error : "User is banned from this group"
        });
        return;
      }

    this.prisma.groupMember
      .create({
        data: {
          user_id: req.body.userId,
          group_id: req.body.groupId,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: "Joined group!",
        });
      })
    } catch(error){
      next(error)
    }
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupLeave(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
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

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupGetAllForUser(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
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
      })
      .catch((error) => {
        res.statusCode = 422;
        next(error);
      });
  }
}
