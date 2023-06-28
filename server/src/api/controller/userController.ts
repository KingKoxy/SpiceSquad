import express = require('express');
import AbstractController from './abstractController';

class UserController extends AbstractController {
    
    constructor() {
        super();
    }

    public async userDelete(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Deleted user!'
        });
    }

    public async userPatch(req: express.Request, res: express.Response): Promise<void>{
        res.status(200).json({
            message: 'Updated user!'
        });
    }
}

export default UserController