import express = require('express')
import AbstractController from './abstractController'
import AuthenticatedRequest from '../middleware/authenticatedRequest'

export default class GroupController extends AbstractController {
  /**
   * @description This constructor calls the constructor of the abstractController.
   * @constructor
   */
  constructor() {
    super()
  }

  /**
   * @description This function creates a new group.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPost(
    req: AuthenticatedRequest<never, never, { groupName: string }>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const user = await this.prisma.user.findFirst({
      where: { id: req.userId },
    })
    if (user.created_groups >= parseInt(process.env.MAXIMUM_USER_GROUPS)) {
      req.statusCode = 409
      next(new Error('User has already created maximum number of groups'))
    }
    this.prisma.group
      .create({
        data: {
          name: req.body.groupName,
          Admin: {
            create: {
              user_id: req.userId,
            },
          },
          groupMember: {
            create: {
              user_id: req.userId,
            },
          },
        },
        include: { Admin: true, groupMember: true },
      })
      .then(() => {
        this.prisma.user
          .update({
            where: { id: req.userId },
            data: { created_groups: { increment: 1 } },
          })
          .then(() => {
            res.status(200).json({
              message: 'Group created successfully!',
            })
          })
          .catch((error) => {
            next(error)
          })
      })
  }

  /**
   * @description This function deletes a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupDelete(
    req: AuthenticatedRequest<
      {
        groupId: string
      },
      never,
      never
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    await this.prisma.group
      .delete({
        where: {
          id: req.params.groupId,
        },
      })
      .then(() => {
        res.status(200).json({
          message: 'Deleted group!',
        })
      })
      .catch((error) => {
        req.statusCode = 500
        next(error)
      })
  }

  /**
   * @description This function updates a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupPatch(
    req: AuthenticatedRequest<
      { groupId: string },
      never,
      {
        name: string
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.group
      .update({
        where: {
          id: req.params.groupId,
        },
        data: req.body.name || undefined,
      })
      .then(() => {
        res.status(200).json({
          message: 'Updated group!',
        })
      })
      .catch((error) => {
        req.statusCode = 500
        next(error)
      })
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupJoin(
    req: AuthenticatedRequest<
      never,
      never,
      {
        groupCode: string
      }
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    try {
      const groupId = (
        await this.prisma.group.findFirst({
          where: {
            group_code: req.body.groupCode,
          },
        })
      ).id
      await this.prisma.bannedUser
        .findFirst({
          where: {
            user_id: req.userId,
            group_id: groupId,
          },
        })
        .then((result) => {
          if (result) {
            req.statusCode = 403
            throw new Error('User is banned from this group')
          }
        })
      //TODO: check if group has places left
      this.prisma.groupMember
        .create({
          data: {
            user_id: req.userId,
            group_id: groupId,
          },
        })
        .then(() => {
          res.status(200).json({
            message: 'Joined group!',
          })
        })
    } catch (error) {
      next(error)
    }
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @returns Promise<void>
   */
  public async groupLeave(
    req: AuthenticatedRequest<
      {
        groupId: string
      },
      never,
      never
    >,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    const result = await this.prisma.groupMember.findMany({
      where: {
        user_id: req.userId,
        group_id: req.params.groupId,
      },
    })
    if (result.length == 0) {
      req.statusCode = 409
      next(new Error('Could not left group. User is not in this group'))
    } else if (result.length == 1) {
      this.prisma.group
        .delete({
          where: {
            id: req.params.groupId,
          },
        })
        .then((result) => {
          res.status(200).json({
            message: 'User was last member of group. Group deleted.',
          })
        })
        .catch((error) => {
          next((error.message = 'Group could not be left'))
        })
    }

    const result2 = await this.prisma.admin.findMany({
      where: {
        user_id: req.userId,
        group_id: req.params.groupId,
      },
    })
    if (result2.length == 1) {
      const result3 = await this.prisma.groupMember.findMany({
        where: {
          group_id: req.params.groupId,
        },
        orderBy: {
          joined_at: 'asc',
        },
      })
      this.prisma.admin
        .create({
          data: {
            user_id: result3[0].user_id,
            group_id: req.params.groupId,
          },
        })
        .then((result) => {
          console.log('Longest group member is now admin.')
        })
        .catch((error) => {
          req.statusCode = 500
          next((error.message = 'Group could not be left'))
        })
    }

    this.prisma.groupMember
      .deleteMany({
        where: {
          user_id: req.userId,
          group_id: req.params.groupId,
        },
      })
      .then((result) => {
        res.status(200).json({
          message: 'Left group!',
        })
      })
      .catch((error) => {
        next(error)
      })
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupGetAllForUser(
    req: AuthenticatedRequest<never, never, never>,
    res: express.Response,
    next: express.NextFunction
  ): Promise<void> {
    this.prisma.group
      .findMany({
        where: {
          groupMember: {
            some: {
              user_id: req.userId,
            },
          },
        },
      })
      .then((result) => {
        console.log(result)
        res.status(200).json(result)
      })
      .catch((error) => {
        next(error)
      })
  }

  /**
   * @description This function gets a group by id.
   * @param req Express request handler
   * @param res Express response handler
   * @param next Express next function (for error handling)
   * @returns Promise<void>
   */
  public async groupGetById(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
    this.prisma.group
      .findMany({
        where: {
          id: req.params.groupId,
        },
      })
      .then((result) => {
        res.status(200).json(result)
      })
      .catch((error) => {
        next(error)
      })
  }
}
