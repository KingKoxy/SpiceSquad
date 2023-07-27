import chai, { expect } from 'chai';
import express from 'express';
import sinon from 'sinon';
import chaiHttp from 'chai-http'; // Import chai-http module
import AdminUserRouter from '../src/api/router/adminUserRouter';
import AdminUserController from '../src/api/controller/adminUserController';
import CheckAdminStatus from '../src/api/middleware/checkAdminStatus';
import checkGroupMemberState from '../src/api/middleware/checkGroupMemberState';

chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('AdminUserRouter', () => {
  let app;
  let adminUserRouter;

  beforeEach(() => {
    app = express();
    adminUserRouter = new AdminUserRouter();
  });

  it('should setup routes with correct middleware and controller methods', () => {
    // Mock the middleware functions
    const checkAuthMock = (req, res, next) => next();
    const checkAdminMock = (req, res, next) => next();
    const checkMemberStateTargetMock = (req, res, next) => next();

    // Replace the actual middleware with the mock functions
    adminUserRouter.checkAuth = checkAuthMock;
    adminUserRouter.checkAdminStatus = new CheckAdminStatus();
    adminUserRouter.checkAdmin = checkAdminMock;
    adminUserRouter.checkGroupMemberState = new checkGroupMemberState();
    adminUserRouter.checkMemberStateTarget = checkMemberStateTargetMock;

    // Use the routes
    adminUserRouter.setupRoutes();

    // Mock the controller methods
    const adminUserController = new AdminUserController();
    const makeAdminSpy = sinon.spy(adminUserController, 'makeAdmin');
    const removeAdminSpy = sinon.spy(adminUserController, 'removeAdmin');
    const kickUserSpy = sinon.spy(adminUserController, 'kickUser');
    const banUserSpy = sinon.spy(adminUserController, 'banUser');
    const setCensoredSpy = sinon.spy(adminUserController, 'setCensored');

    // Replace the actual controller with the mock controller
    adminUserRouter.Controller = adminUserController;

    // Test the routes
    app.use('/admin', adminUserRouter.getRouter());

    return Promise.all([
      chai
        .request(app)
        .patch('/admin/makeAdmin/groupId/targetId')
        .then((res) => {
          expect(res).to.have.status(200);
          expect(makeAdminSpy.calledOnce).to.be.true;
        }),
      chai
        .request(app)
        .patch('/admin/removeAdmin/groupId/targetId')
        .then((res) => {
          expect(res).to.have.status(200);
          expect(removeAdminSpy.calledOnce).to.be.true;
        }),
      chai
        .request(app)
        .patch('/admin/kickUser/groupId/targetId')
        .then((res) => {
          expect(res).to.have.status(200);
          expect(kickUserSpy.calledOnce).to.be.true;
        }),
      chai
        .request(app)
        .patch('/admin/banUser/groupId/targetId')
        .then((res) => {
          expect(res).to.have.status(200);
          expect(banUserSpy.calledOnce).to.be.true;
        }),
      chai
        .request(app)
        .patch('/admin/setCensored/groupId/recipeId')
        .then((res) => {
          expect(res).to.have.status(200);
          expect(setCensoredSpy.calledOnce).to.be.true;
        }),
    ]);
  });
});