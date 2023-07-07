import express = require("express");
import AbstractController from "./abstractController";

/**
 * @description This class contains the controller for the user router.
 * @class UserRouter
 * @extends abstractRouter
 * @exports UserRouter
 * @version 1.0.0
 * @requires UserController
 * @requires express
 */
export default class UserController extends AbstractController {

  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   * @param void
   */
  constructor() {
    super();
  }

  /**
   * @description This function gets all users.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userDelete(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.user
      .delete({
        where: {
          id: req.params.id,
        },
      })
      .then((user) => {
        this.firebaseAdmin
          .auth()
          .deleteUser(user.firebase_user_id)
          .catch((error) => {
            res.status(500).json({
              error: error,
            });
          });
        res.status(200).json({
          message: "User deleted successfully!",
        });
      })
      .catch((error) => {
        req.statusCode = 409;
        next(error);
      });
  }

  /**
   * @description This function gets all users.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async userPatch(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.user
      .update({
        where: {
          id: req.params.id,
        },
        data: {
          user_name: req.body.name,
          email: req.body.email,
          profile_image: req.body.profile_image,
        },
      })
      .then((user) => {
        res.status(200).json({
          message: "User updated successfully!",
        });
      })
      .catch((error) => {
        req.statusCode = 409;
        next(error);
      });
  }
}
