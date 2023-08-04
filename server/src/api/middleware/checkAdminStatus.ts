import express = require('express')
import AbstractMiddleware from './abstractMiddleware'
import AuthenticatedRequest from './authenticatedRequest'

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
   * @description This function checks the admin status of a user. Throws an error if the user is not an admin.
   * @memberof CheckAdminStatus
   * @param req - The request object.
   * @param res - The response object.
   * @param next - The next function.
   * @async
   */
  public async checkAdminStatus(
    req: AuthenticatedRequest,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.group
      .findFirst({
        where: {
          id: req.params.groupId,
        },
      })
      .then((result) => {
        console.log(req.userId)

        if (!result) {
          req.statusCode = 404
          next(new Error('Group not found'))
        }
      })
    await this.prisma.admin
      .findMany({
        where: {
          user_id: req.userId,
          group_id: req.params.groupId,
        },
      })
      .then((result) => {
        console.log(result[0])

        if (result.length > 0) {
          next()
        } else {
          req.statusCode = 401
          next(new Error('The user is not an admin of this group'))
        }
      })
  }
}
