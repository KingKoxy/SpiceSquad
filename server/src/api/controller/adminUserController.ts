import express = require('express');
import AbstractController from './abstractController';

class AdminUserController extends AbstractController {
    
    constructor() {
        super();
    }

    public async makeAdmin(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling POST request to /admin/user'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }

    public async removeAdmin(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling DELETE request to /admin/user'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }

    public async kickUser(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling DELETE request to /admin/user'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }

    public async banUser(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling DELETE request to /admin/user'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }

    public async setCensored(req: express.Request, res: express.Response): Promise<void> {
        try {
            res.status(200).json({
                message: 'Handling PUT request to /admin/user'
            });
        } catch (error) {
            res.status(500).json({ error: 'Internal server error'});
        }
    }
}


export default AdminUserController