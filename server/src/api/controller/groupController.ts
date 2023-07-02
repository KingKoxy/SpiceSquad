import express = require('express');
import AbstractController from './abstractController';
import schema from '../../../prisma/schemas/groupSchema';

class GroupController extends AbstractController {

    constructor() {
        super();
    }

    public async groupPost(req: express.Request, res: express.Response): Promise<void> {
        console.log(req.body);
        const {error, value} = schema.validate(req.body);
        if (error) {
            res.status(422).json({ error: error.details[0].message });
            return;
        }
        
        this.prisma.group.create({
            data: {
                name: req.body.name
            }
        }).then((result) => {
            this.prisma.groupMember.create({
                data: {
                    user_id: req.body.user_id,
                    group_id: result.id
                }
            });
            this.prisma.admin.create({
                data: {
                    user_id: req.body.user_id,
                    group_id: result.id
                }
            });
            res.status(200).json({
                message: "Group created successfully!",
            });
        })
        /*this.pool.query('INSERT INTO "group" (name) VALUES ($1) RETURNING id', [req.body.name])
        .then((result) => {
            this.pool.query('INSERT INTO "groupmember" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
            this.pool.query('INSERT INTO "admin" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
            res.status(200).json({
                message: "Group created successfully!",
            });
        }) */
    }

    public async groupDelete(req: express.Request, res: express.Response): Promise<void> {
        this.prisma.group.delete({
            where: {
                id: req.body.group_id
            }
        }).then((result) => {
            res.status(200).json({
                message: 'Deleted group!'
            });
        })
    }

    public async groupPatch(req: express.Request, res: express.Response): Promise<void>{
        this.prisma.group.update({
            where: {
                id: req.body.group_id
            },
            data: {
                name: req.body.name
            }
        }).then((result) => {
            res.status(200).json({
                message: 'Updated group!'
            });
        })
    }

    public async groupJoin(req: express.Request, res: express.Response): Promise<void>{
        res.status(200).json({
            message: 'Joined group!'
        });
    }

    public async groupLeave(req: express.Request, res: express.Response): Promise<void>{
        res.status(200).json({
            message: 'Left group!'
        });
    }

    public async groupGetAllForUser(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Handling GET requests to /groups'
        });
    }

}

export default GroupController