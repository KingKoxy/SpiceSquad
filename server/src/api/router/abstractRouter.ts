import express = require('express');

abstract class abstractRouter {
    protected router: express.Router;
    protected checkAuth: any;

    constructor() {
        this.router = express.Router();
    }

    protected abstract setupRoutes(): void;

    public getRouter(): express.Router {
        return this.router;
    };
}

export default abstractRouter