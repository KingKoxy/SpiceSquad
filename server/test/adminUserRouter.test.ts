import chai, { expect, use } from 'chai';
import Server from '../src/server';
import chaiHttp from 'chai-http'; // Import chai-http module


chai.use(chaiHttp); // Extend chai with chai-http plugin

require('./groupRouter.test')

describe('AdminUserRouter', () => {
    let server = new Server()	;

    var idTokenAd : string;
    var idTokenUser : string;
    var idTokenUser2 : string;
    var admingroupId : string;

    var userId  : string;

    var res;

    it('should successfully kick user', async () => {
        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'indila@mailbox.org',
                password: '12345678'
            })
        
        idTokenAd = res.body.idToken;

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'heinrich.holdensack@mailbox.org',
                password: '12345678'
            })

        idTokenUser = res.body.idToken;

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'blubberbernd@mailbox.org',
                password: '12345678'
            })
                
        idTokenUser2 = res.body.idToken;
        
        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .get('/group')
            .set('content-type', 'application/json')
            .set("Authorization", idTokenUser2)

        expect(res).status(200);
        admingroupId = res.body.groups[0].id;
        var code = res.body.groups[0].group_code;

        console.log("code: " + code);
        console.log("idTokenUser: " + idTokenUser);

        res = await chai.request('http://localhost:3000')
            .patch('group/join')
            .set('content-type', 'application/json')
            .set("Authorization", idTokenUser)
            .send({
                groupCode: code
            })

        expect(res).status(200);

        console.log("1")
        var res = await chai.request('http://localhost:3000')
            .get('/user')
            .set('content-type', 'application/json')
            .set("Authorization", idTokenUser)
        
        expect(res).status(200);

        userId = res.body.id;

        console.log("2")
        res = await chai.request('http://localhost:3000')
            .patch('admin/kickUser/' + admingroupId + '/' + userId)
            .set('content-type', 'application/json')
            .set("Authorization", idTokenAd)

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .get('/group/' + admingroupId)
            .set('content-type', 'application/json')
            .set("Authorization", idTokenAd)

        expect(res).status(200);

        expect(res.body.group.members.length).to.equal(2);

    });

});
