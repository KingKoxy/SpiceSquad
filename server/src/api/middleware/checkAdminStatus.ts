import firebase = require("firebase-admin");
import express = require("express");
import abstractMiddleware from "./abstractMiddleware";

/**
 * @class CheckAdminStatus
 * @description This class is used to check the admin status of a user.
 * @exports CheckAdminStatus
 * @version 1.0.0
 * @extends abstractMiddleware
 * @requires firebase-admin
 * @requires express
 */
export default class CheckAdminStatus extends abstractMiddleware{

  /**
   * @constructor This constructor initializes the check admin status middleware.
   * @memberof CheckAdminStatus
   * @instance
   * @returns {void}
   * @protected
  */
  constructor() {
    super();
  }

  /**
   * @function checkAdminStatus
   * @description This function checks the admin status of a user.
   * @memberof CheckAdminStatus
   * @async
   */
  public async checkAdminStatus(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.admin.findMany({
      where: {
        user_id: req.body.user_id,
        group_id: req.body.group_id
      }
    }).then((result) => {
      if (result.length > 0) {
        next();
      } else {
        req.statusCode = 401;
        next(new Error("No valid admin"));
      }
    });
  }
}
