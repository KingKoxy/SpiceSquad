import express = require('express');
import AbstractController from './abstractController';

class UserController extends AbstractController {
    
    constructor() {
        super();
    }

    public async userDelete(req: express.Request, res: express.Response): Promise<void> {
        this.prisma.user.delete({
            where: {
                id: req.params.id
            }
        }).then((user) => {
            this.firebaseAdmin.auth().deleteUser(user.firebase_user_id).catch((error) => {
                res.status(500).json({
                    error: error
                    });
            });
            res.status(200).json({
                message: "User deleted successfully!",
            });

        }).catch((error) => {
            res.status(500).json({
                error: error
                });
        });
    }

    public async userPatch(req: express.Request, res: express.Response): Promise<void>{
        this.prisma.user.update({
            where: {
                id: req.params.id
            },
            data: {
                user_name: req.body.name,
                email: req.body.email,
            }
        }).then((user) => {
            res.status(200).json({
                message: "User updated successfully!",
            });

        }).catch((error) => {
            res.status(500).json({
                error: error
                });
        });
    }
}

export default UserController