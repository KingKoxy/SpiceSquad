import express = require('express');
import AbstractController from './abstractController';

class AuthentificationController extends AbstractController {
    
    constructor() {
        super();
    }

    public userLogin(req: express.Request, res: express.Response) {
        res.json({ message: 'POST new recipe' });
    }

    public userRegister(req: express.Request, res: express.Response) {
        try {
            res.status(200).json({
                message: 'Handling POST request to /groups'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }

    public userResetPassword(req: express.Request, res: express.Response) {
        try {
            res.status(200).json({
                message: 'Handling POST request to /groups'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }
}

export default AuthentificationController