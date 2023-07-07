import firebase = require("firebase-admin");
import express = require("express");
import { PrismaClient } from "@prisma/client";
import abstractMiddleware from "./abstractMiddleware";

/**
 * @class CheckAuthorization
 * @description This class is used to check the authorization of a request.
 * @exports CheckAuthorization
 * @version 1.0.0
 * @extends abstractMiddleware
 * @requires firebase
 * @requires express
 * @requires PrismaClient
 * @requires abstractMiddleware
 */
export default class CheckAuthorization extends abstractMiddleware {

  /**
   * @constructor This constructor initializes the check authorization middleware.
   * @memberof CheckAuthorization
   */
  constructor() {
    super();
  }

  /**
   * @function checkAuthorization
   * @description This function checks the authorization of a request.
   * @memberof CheckAuthorization
   * @param {express.Request} req - The request.
   * @param {express.Response} res - The response.
   * @param {express.NextFunction} next - The next function.
   * @returns {Promise<void>}
   * @public
   * @async
   */
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
              req.body.userId = user.id;
            });
          next();
        })
        .catch((error) => {
          req.statusCode = 401;
          next(error);
        });
  }
}
