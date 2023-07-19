import express = require('express')
import morgan = require('morgan')

import RecipeRouter from './api/router/recipeRouter'
import GroupRouter from './api/router/groupRouter'
import UserRouter from './api/router/userRouter'
import IngredientRouter from './api/router/ingredientRouter'
import AdminUserRouter from './api/router/adminUserRouter'
import AuthenticationRouter from './api/router/authenticationRouter'

/**
 * @class Application
 * @description This class is used to initialize the application.
 * @exports Application
 * @version 1.0.0
 * @extends express.Application
 * @requires express
 * @requires morgan
 * @requires recipeRouter
 * @requires groupRouter
 * @requires userRouter
 * @requires ingredientRouter
 * @requires adminUserRouter
 * @requires authentificationRouter
 */
export default class Application {
  private app: express.Application

  private authenticationRoutes: AuthenticationRouter
  private recipeRoutes: RecipeRouter
  private groupRoutes: GroupRouter
  private userRoutes: UserRouter
  private ingredientRoutes: IngredientRouter
  private adminUserRoutes: AdminUserRouter

  /**
   * @constructor
   * @description This constructor initializes the application.
   * @param {express.Application} express - The express application.
   * @memberof Application
   * @instance
   * @returns {void}
   */
  constructor(express: express.Application) {
    this.app = express
    this.authenticationRoutes = new AuthenticationRouter()
    this.recipeRoutes = new RecipeRouter()
    this.groupRoutes = new GroupRouter()
    this.userRoutes = new UserRouter()
    this.ingredientRoutes = new IngredientRouter()
    this.adminUserRoutes = new AdminUserRouter()

    this.initializeMiddleware()
    this.initializeRoutes()
    this.initializeErrorHandlers()
  }

  private initializeMiddleware(): void {
    if (process.env.NODE_ENV === 'development') {
      this.app.use(morgan('dev'))
    }
    try {
      this.app.use(express.json({limit: '50mb'}));
    } catch (error) {
      console.log(error)
    }
  }

  private initializeRoutes(): void {
    this.app.use('/auth', this.authenticationRoutes.getRouter())
    this.app.use('/recipe', this.recipeRoutes.getRouter())
    this.app.use('/group', this.groupRoutes.getRouter())
    this.app.use('/user', this.userRoutes.getRouter())
    this.app.use('/ingredient', this.ingredientRoutes.getRouter())
    this.app.use('/admin', this.adminUserRoutes.getRouter())
  }

  private initializeErrorHandlers(): void {
    this.app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
      const error = new Error('The URL you are trying to reach does not exist.')
      req.statusCode = 404
      next(error)
    })

    this.app.use((error: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
      res.status(req.statusCode || 500).json({
        error: {
          message: error.message,
          stack: process.env.NODE_ENV === 'development' ? error.stack : undefined,
        },
        requestBody: req.body
      })
    })
  }
}
