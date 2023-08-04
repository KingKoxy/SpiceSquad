// test/application.test.ts
import { expect } from 'chai';
import express from 'express';
import Application from '../src/application';
import AuthenticationRouter from '../src/api/router/authenticationRouter';
import RecipeRouter from '../src/api/router/recipeRouter';
import GroupRouter from '../src/api/router/groupRouter';
import UserRouter from '../src/api/router/userRouter';
import IngredientRouter from '../src/api/router/ingredientRouter';
import AdminUserRouter from '../src/api/router/adminUserRouter';
require('./server.test');

/*describe('Application', () => {
  let app: express.Application;
  const preInitializeRouterAmount = 12;

  const routerClassAmount = 6;
  const errorHandlersAmount = 2;
  
  process.env.NODE_ENV = 'development';

  beforeEach(() => {
    app = express();
  });

  it('should initialize application and middleware', () => {
    // Creating the application
    const application = new Application(app);

    // Stubbing getRouter function for each router class
    const routerStub = () => ({ getRouter: () => app });
    const routerClasses = [
      AuthenticationRouter,
      RecipeRouter,
      GroupRouter,
      UserRouter,
      IngredientRouter,
      AdminUserRouter,
    ];

    routerClasses.forEach((routerClass) => {
      // Create an instance of the router class and attach it to the application
      const routerInstance = new routerClass();
      app.use(routerInstance.getRouter());
    });
      console.log(app._router.stack.length);
      console.log(routerClasses.length);
    // Asserting that the routers are initialized
    expect(app._router.stack.length).to.equal(routerClasses.length + preInitializeRouterAmount);
  });

  it('should initialize routes', () => {
    // Creating the application
    const application = new Application(app);

    // Initialize routes
    application['initializeRoutes']();

    // Asserting that app.use is called for each router
    expect(app._router.stack.length).to.be.equal(routerClassAmount + preInitializeRouterAmount);
  });

  it('should initialize error handlers', () => {
    // Creating the application
    const application = new Application(app);

    // Initialize error handlers
    application['initializeErrorHandlers']();

    // Asserting that app.use is called twice for the error handlers
    expect(app._router.stack.length).to.equal(errorHandlersAmount+preInitializeRouterAmount);
  });
  process.env.NODE_ENV = 'test';
});*/