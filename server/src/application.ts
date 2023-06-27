import express = require('express');
import morgan = require('morgan');

import AuthentificationRouter from './api/router/authentificationRouter';


class Application {

    private app : express.Application;
    private authentificationRoutes: AuthentificationRouter;

    constructor(express: express.Application) {
        this.app = express;
        this.authentificationRoutes = new AuthentificationRouter();

        this.initializeMiddleware();
        this.initializeRoutes();
        this.initializeErrorHandlers();
    }

    private initializeMiddleware(): void {
        this.app.use(morgan('dev'));
        this.app.use(express.json());
        this.app.use((req, res, next) => {
          res.header('Access-Control-Allow-Origin', '*');
          res.header(
            'Access-Control-Allow-Headers',
            'Origin, X-Requested-With, Content-Type, Accept, Authorization'
          );
          if (req.method === 'OPTIONS') {
            res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE');
            return res.status(200).json({});
          }
          next();
        });
      }
    
    private initializeRoutes(): void {
      this.app.use('/auth', this.authentificationRoutes.getRouter());
    }
    
      private initializeErrorHandlers(): void {
        this.app.use((req: express.Request, res: express.Response) => {
            console.log('Start');
            const error = new Error('Not found');
            res.status(404).json({
                error: {
                message: error.message,
                }
            });
        });
      }

}
export default Application