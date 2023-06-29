import express = require('express');
import CheckAuthorization from '../middleware/checkAuthorization';
import AbstractController from '../controller/abstractController'

abstract class abstractRouter {
    protected router: express.Router;
    protected checkAuth: any;
    protected Controller: AbstractController;
    protected checkAuthorization: CheckAuthorization;

    constructor() {
        this.router = express.Router();
        this.checkAuthorization = new CheckAuthorization();
        this.checkAuth = this.checkAuthorization.checkAuthorization.bind(this.checkAuthorization);
    }

    protected abstract setupRoutes(): void;

    public getRouter(): express.Router {
        return this.router;
    };
}

export default abstractRouter