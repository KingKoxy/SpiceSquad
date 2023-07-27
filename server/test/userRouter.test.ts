import chai, { expect } from 'chai';
import express from 'express';
import chaiHttp from 'chai-http'; // Import chai-http module
import sinon from 'sinon';
import UserRouter from '../src/api/router/userRouter';
import UserController from '../src/api/controller/userController';
import { userDeleteSchema, userPatchSchema, getUserByTokenSchema } from '../src/schemas/userSchema';

chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('UserRouter', () => {
  let app;
  let userRouter;

  beforeEach(() => {
    app = express();
    userRouter = new UserRouter();
  });

  it('should setup routes with correct middleware and controller methods', () => {
    // Mock the middleware functions
    const checkAuthMock = (req, res, next) => next;
    const checkSchemaMock = (req, res, next) => next;

    // Replace the actual middleware with the mock functions
    userRouter.checkAuth = checkAuthMock;
    userRouter.schemaValidator = {
      checkSchema: checkSchemaMock,
    };

    // Mock the controller methods
    const userController = new UserController();
    const userPatchSpy = sinon.spy(userController, 'userPatch');
    const userGetSpy = sinon.spy(userController, 'userGet');

    // Replace the actual controller with the mock controller
    userRouter.Controller = userController;

    // Use the routes
    userRouter.setupRoutes();

    app.use('/user', userRouter.getRouter());

    // Test the routes
    return Promise.all([


    ]);
  });
});
