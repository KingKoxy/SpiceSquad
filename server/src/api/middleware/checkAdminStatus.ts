import express = require('express')
import AbstractMiddleware from './abstractMiddleware'

/**
 * @class CheckAdminStatus
 * @description This class is used to check the admin status of a user.
 * @exports CheckAdminStatus
 * @version 1.0.0
 * @extends AbstractMiddleware
 * @requires express
 */
export default class CheckAdminStatus extends AbstractMiddleware {
  /**
   * @constructor This constructor initializes the check admin status middleware.
   * @memberof CheckAdminStatus
   * @instance
   * @returns {void}
   * @protected
   */
  constructor() {
    super()
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
    await this.prisma.group
      .findMany({
        where: {
          id: req.params.groupId,
        },
      })
      .then((result) => {
        if (result.length == 0) {
          req.statusCode = 404
          next(new Error('Group not found'))
        }
      })
    await this.prisma.admin
      .findMany({
        where: {
          user_id: req.body.userId,
          group_id: req.params.groupId,
        },
      })
      .then((result) => {
        if (result.length > 0) {
          next()
        } else {
          req.statusCode = 401
          next(new Error('The user is not an admin of this group'))
        }
      })
  }
}
