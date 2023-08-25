import chai, { expect } from 'chai';
import chaiHttp from 'chai-http'; // Import chai-http module
import Server from '../src/server';

require('./application.test')
chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('AuthentificationRouter', () => {
  let server;

  beforeEach(() => {
    server = new Server();
  });

  var idToken : string;
  var refreshToken : string;
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

      await chai.request('http://localhost:3000')
        .post('/auth/register')
        .set('content-type', 'application/json')
        .send({
          userName: 'Blubberbernd',
          email: 'blubberbernd@mailbox.org',
          password: '12345678'
        })


      expect(logindata).status(200);

      idToken = logindata.body.idToken;
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

    it('should successfully login user', async () => {
      var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'indila@mailbox.org',
        password: '12345678'
      })

      expect(logindata).status(200);

      refreshToken = logindata.body.refreshToken;
      idToken = logindata.body.idToken;
    });

    it('should successfully refresh user', async () => {
      var res = await chai.request('http://localhost:3000')
      .post('/auth/refreshToken')
      .set('content-type', 'application/json')
      .send({
        refreshToken: refreshToken
      })

      expect(res).status(200);

      idToken = res.body.idToken;
    });

    it('should successfully logout user', async () => {
      var res = await chai.request('http://localhost:3000')
      .post('/auth/logout')
      .set('content-type', 'application/json')
      .set("Authorization", idToken)

      expect(res).status(200);
    });
      
});