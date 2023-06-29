import firebase = require('firebase-admin');
import express = require('express');
import pg = require('pg');
import Database from '../../database';

class CheckAuthorization {

    protected database: Database;
    protected pool: pg.Pool;

    constructor(){
        this.database = new Database();
        this.pool = this.database.getPool();
    }

    public async checkAuthorization(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        const token = req.get('Authorization');
        let uid: string;
        try {
            firebase.auth().verifyIdToken(token).then(async (decodedToken) => {
                uid = decodedToken.uid;
                req.body.user_id = (await this.pool.query('SELECT id FROM "user" WHERE firebase_user_id = $1', [uid])).rows[0].id;
                next();
            }).catch((error) => {
                res.status(401).json({message: 'No valid user'});
            });
        } catch(error) {
            res.status(401).json({message: 'Some error occurred'});
        };
    };
}

export default CheckAuthorization