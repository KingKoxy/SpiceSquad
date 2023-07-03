import firebase = require("firebase-admin");
import morgan = require("morgan");
import express = require("express");
import pg = require("pg");
import { PrismaClient } from "@prisma/client";
import Database from "../../database";

class CheckAdminStatus {
  protected database: Database;
  protected pool: pg.Pool;
  protected prisma: PrismaClient;

  constructor() {
    this.database = new Database();
    this.pool = this.database.getPool();
    this.prisma = new PrismaClient();
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
        res.status(401).json({ message: "No valid admin:" });
      }
    });
  }
}

export default CheckAdminStatus;
