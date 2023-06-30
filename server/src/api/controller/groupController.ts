import express = require('express');
import AbstractController from './abstractController';

class GroupController extends AbstractController {

    constructor() {
        super();
    }

    public async groupPost(req: express.Request, res: express.Response): Promise<void> {
        const requireParams = ["name"];
        const missingParams = requireParams.filter(param => !(param in req.body));
        if (missingParams.length > 0) {
            res.status(400).json({
                error: 'Missing parameters: ' + missingParams.join(', ')
            });
            return;
        }
        
        this.pool.query('INSERT INTO "group" (name) VALUES ($1) RETURNING id', [req.body.name])
        .then((result) => {
            this.pool.query('INSERT INTO "groupmember" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
            this.pool.query('INSERT INTO "admin" (user_id, group_id) VALUES ($1, $2)', [req.body.user_id, result.rows[0].id]);
            res.status(200).json({
                message: "Group created successfully!",
            });
        })
    }

    public async groupDelete(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Deleted group!'
        });
    }

    public async groupPatch(req: express.Request, res: express.Response): Promise<void>{
        res.status(200).json({
            message: 'Updated group!'
        });
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