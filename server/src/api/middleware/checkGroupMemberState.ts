import firebase = require('firebase-admin')
import express = require('express')
import abstractMiddleware from './abstractMiddleware'

export default class checkGroupMemberState extends abstractMiddleware {
  constructor() {
    super()
  }

  /**
   * @description This function checks wether the target user is a member of the group.
   * @param {AuthenticatedRequest} req - The request.
   * @param {express.Response} res - The response.
   * @param {express.NextFunction} next - The next function.
   */
  public async checkMemberStateTarget(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.groupMember
      .findFirst({
        where: {
          user_id: req.params.targetId,
          group_id: req.params.groupId,
        },
      })
      .then((result) => {
        if (!result) {
          req.statusCode = 404
          next(Error('User is not a member!'))
        }
        next()
      })
  }
}
