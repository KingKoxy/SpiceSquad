import express = require('express');
import morgan = require('morgan');

import RecipeRouter from './api/router/recipeRouter';
import GroupRouter from './api/router/groupRouter';
import UserRouter from './api/router/userRouter';
import IngredientRouter from './api/router/ingredientRouter';
import AdminUserRouter from './api/router/adminUserRouter';
import AuthentificationRouter from './api/router/authentificationRouter';


class Application {

    private app : express.Application;

    private authentificationRoutes: AuthentificationRouter;
    private recipeRoutes: RecipeRouter;
    private groupRoutes: GroupRouter;
    private userRoutes: UserRouter;
    private ingredientRoutes: IngredientRouter;
    private adminUserRoutes: AdminUserRouter;

    
    constructor(express: express.Application) {
        this.app = express;
        this.authentificationRoutes = new AuthentificationRouter();
        this.recipeRoutes = new RecipeRouter();
        this.groupRoutes = new GroupRouter();
        this.userRoutes = new UserRouter();
        this.ingredientRoutes = new IngredientRouter();
        this.adminUserRoutes = new AdminUserRouter();

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
      this.app.use('/recipe', this.recipeRoutes.getRouter());
      this.app.use('/group', this.groupRoutes.getRouter());
      this.app.use('/user', this.userRoutes.getRouter());
      this.app.use('/ingredient', this.ingredientRoutes.getRouter());
      this.app.use('/admin', this.adminUserRoutes.getRouter());
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