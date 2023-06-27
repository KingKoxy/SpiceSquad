import express = require('express');
import morgan = require('morgan');

class Application {

    private app : express.Application;

    constructor(express: express.Application) {
        this.app = express;

        this.initializeMiddleware();
        this.initializeRoutes();
        this.initializeErrorHandlers();
    }

    private initializeMiddleware(): void {
        this.app.use(morgan('dev'));
        this.app.use(express.json());
        this.app.use((req, res, next) => {
          res.header('Access-Control-Allow-Origin', '*');
          next();
        });
      }
    
    private initializeRoutes(): void {

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