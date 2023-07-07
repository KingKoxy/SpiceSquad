import firebase = require("firebase-admin");
import express = require("express");
import { PrismaClient } from "@prisma/client";
import abstractMiddleware from "./abstractMiddleware";

class CheckAuthorization extends abstractMiddleware {

  constructor() {
    super();
  }

  public async checkAuthorization(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    if (req.get("Authorization") === undefined) {
      req.statusCode = 401;
      next(new Error("No Authorization header provided"));
      return;
    }
    const token = req.get("Authorization");
    let uid: string;
      firebase
        .auth()
        .verifyIdToken(token)
        .then(async (decodedToken) => {
          uid = decodedToken.uid;
          console.log(uid);
          await this.prisma.user
            .findUnique({
              where: {
                firebase_user_id: uid,
              },
            })
            .then((user) => {
              console.log(user);
              req.body.user_id = user.id;
            });
          next();
        })
        .catch((error) => {
          req.statusCode = 401;
          next(error);
        });
  }
}

export default CheckAuthorization;
