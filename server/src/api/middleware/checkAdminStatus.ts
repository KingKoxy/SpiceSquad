import firebase = require('firebase-admin');
import morgan = require('morgan');
import express = require('express');

class CheckAdminStatus {


    constructor(){

    }

    public async checkAdminStatus(req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> {
        next();
    };
}

export default CheckAdminStatus