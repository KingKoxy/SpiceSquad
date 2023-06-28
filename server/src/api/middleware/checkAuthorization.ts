import firebase = require('firebase-admin');
import morgan = require('morgan');
import express = require('express');

class CheckAuthorization {


    constructor(){}

    public async checkAuthorization(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        
        const token = req.get('Authorization');
        next();
        /** Auskommentiert zum Testen der Controller
        try {
            morgan('dev');
            firebase.auth().verifyIdToken(token).then((decodedToken) => {
                const uid = decodedToken.uid;
                next();
            }).catch((error) => {
                res.status(401).json({message: 'Handle error; checkAuthorization'});
            });
        } catch(error) {
            res.status(401).json({message: 'No valid user'});
        };
         */
    };
}

export default CheckAuthorization