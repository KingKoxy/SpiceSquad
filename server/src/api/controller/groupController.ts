import express = require('express');
import AbstractController from './abstractController';

class GroupController extends AbstractController {

    constructor() {
        super();
    }

    public async groupPost(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling POST request to /groups'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
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