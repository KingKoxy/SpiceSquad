import chai, { expect } from 'chai';
import chaiHttp from 'chai-http'; // Import chai-http module
import Server from '../src/server';

//require('./authentificationRouter.test')
chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('UserRouter', () => {
  let server;

  beforeEach(() => {
    server = new Server();
  });

  it('should successfully delete users', async () => {
    var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'indila@mailbox.org',
        password: '12345678'
      })
      
      var idToken : string = logindata.body.idToken;
    
    var res = await chai.request('http://localhost:3000')
      .delete('/user')
      .set('content-type', 'application/json')
      .set("Authorization", idToken)

    expect(res).status(200);

    var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'heinrich.holdensack@mailbox.org',
        password: '12345678'
      })

    idToken = logindata.body.idToken;

    res = await chai.request('http://localhost:3000')
      .delete('/user')
      .set('content-type', 'application/json')
      .set("Authorization", idToken)

    expect(res).status(200);



      
  });
});
