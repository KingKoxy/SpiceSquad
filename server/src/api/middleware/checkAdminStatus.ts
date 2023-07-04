import firebase = require("firebase-admin");
import morgan = require("morgan");
import express = require("express");
import abstractMiddleware from "./abstractMiddleware";

class CheckAdminStatus extends abstractMiddleware{

  constructor() {
    super();
  }

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

export default CheckAdminStatus;
