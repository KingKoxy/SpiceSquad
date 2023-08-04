import chai, { expect } from 'chai';
import chaiHttp from 'chai-http'; // Import chai-http module
import Server from '../src/server';

chai.use(chaiHttp); // Extend chai with chai-http plugin

describe('UserRouter', () => {
  let server;
  var idToken : string;
  beforeEach(() => {
    server = new Server();
  });

  it('should successfully get user', async () => {
    var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'indila@mailbox.org',
        password: '12345678'
      })

    idToken = logindata.body.idToken;

    var res = await chai.request('http://localhost:3000')
      .get('/user')
      .set('content-type', 'application/json')
      .set("Authorization", idToken)

    expect(res).status(200);
    expect(res.body).to.have.property('user_name');
    expect(res.body).to.have.property('email');
    expect(res.body).to.have.property('id');

    expect(res.body.user_name).to.equal('Indila');
    expect(res.body.email).to.equal('indila@mailbox.org');
  });



  it('should successfully delete users', async () => { 
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

    var logindata = await chai.request('http://localhost:3000')
      .post('/auth/login')
      .set('content-type', 'application/json')
      .send({
        email: 'blubberbernd@mailbox.org',
        password: '12345678'
      })

    idToken = logindata.body.idToken;

    var res = await chai.request('http://localhost:3000')
      .delete('/user')
      .set('content-type', 'application/json')
      .set("Authorization", idToken)

    expect(res).status(200);

      
  });
});
