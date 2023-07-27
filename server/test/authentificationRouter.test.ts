import chai, { expect } from 'chai';
import express = require('express');
import chaiHttp from 'chai-http'; // Import chai-http module
import Server from '../src/server';
import { userDeleteSchema, userPatchSchema, getUserByTokenSchema } from '../src/schemas/userSchema';
import AdminUserRouter from '@/api/router/adminUserRouter';
import AuthenticationRouter from '../src/api/router/authenticationRouter';
import CheckAdminStatus from '../src/api/middleware/checkAdminStatus';
require('./application.test');

chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('UserRouter', () => {
  let server;

  beforeEach(() => {
    server = new Server();
  });

  it('should successfully register users', async () => {

      logindata = await chai.request('http://localhost:3000')
      .post('/auth/register')
      .set('content-type', 'application/json')
      .send({
        userName: 'Inci',
        email: 'heinrich.holdensack@mailbox.org',
        password: '12345678'
      })

      expect(logindata).status(200);

      var logindata = await chai.request('http://localhost:3000')
      .post('/auth/register')
      .set('content-type', 'application/json')
      .send({
        userName: 'Indila',
        email: 'indila@mailbox.org',
        password: '12345678'
      })

      expect(logindata).status(200);
  });

  it('should fail creating users with invalid data', async () => {
    
    //No password
    var logindata = await chai.request('http://localhost:3000')
      .post('/auth/register')
      .set('content-type', 'application/json')
      .send({
        userName: 'Max Mustermann',
        email: 'mlpd@gmail.com'})

    expect(logindata).status(422);
    
    //No email
    logindata = await chai.request('http://localhost:3000')
      .post('/auth/register')
      .set('content-type', 'application/json')
      .send({
        userName: 'Max Mustermann',
        password: '12345678'})

    expect(logindata).status(422);

    //No name
    logindata = await chai.request('http://localhost:3000')
      .post('/auth/register')
      .set('content-type', 'application/json')
      .send({
        email: 'amon.gus@gmx.com',
        passwort: '12345678'})
    
    expect(logindata).status(422);

    //Already existing user
    });

    it('should successfully login user', async () => {
      var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'indila@mailbox.org',
        password: '12345678'
      })

      expect(logindata).status(200);
    });

    it('should fail login with invalid data', async () => {
      var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'indila@mailbox.org',
        password: '123456789'
      })

      expect(logindata).status(401);

    });
      
});
    