import firebase = require('firebase-admin')
import express = require('express')
import abstractMiddleware from './abstractMiddleware'

export default class checkGroupMemberState extends abstractMiddleware {
  constructor() {
    super()
  }

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
          req.statusCode = 422
          next(Error('User is not a member!'))
        }
        next()
      })
  }
}
