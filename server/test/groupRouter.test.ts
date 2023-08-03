import chai, { expect, use } from 'chai';
import Server from '../src/server';
import chaiHttp from 'chai-http'; // Import chai-http module

require('./authentificationRouter.test')
chai.use(chaiHttp); // Extend chai with chai-http plugin


describe('GroupRouter', async () => {
    let server = new Server()	;

    var idTokenAd : string;
    var idTokenUser : string;
    var idTokenUser2 : string;
    var deletegroupId : string;
    var leavergroupId : string;
    var res;
    var groups;

    it('should fail joining groups with invalid or nonexistant codes', async () => {
        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'indila@mailbox.org',
                password: '12345678'
            }) 
        
        idTokenAd = res.body.idToken;

        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'heinrich.holdensack@mailbox.org',
                password: '12345678'
            })
        
        idTokenUser = res.body.idToken;

        res = await chai.request('http://localhost:3000')
            .post('/auth/login')
            .set('content-type', 'application/json')
            .send({
                email: 'blubberbernd@mailbox.org',
                password: '12345678'
            })

        idTokenUser2 = res.body.idToken;

        res = await chai.request('http://localhost:3000')
            .patch('/group/join/')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupCode: '755RQO69'
            })

        expect(res).status(404);

        res = await chai.request('http://localhost:3000')
            .patch('/group/join/')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupCode: '755B8'
            })

        expect(res).status(404);

    });

    it('should successfully create groups', async () => {

        res = await chai.request('http://localhost:3000')
            .post('/group')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupName: 'Deletegroup'
            })

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .post('/group')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupName: 'Leavegroup'
            })

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .post('/group')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupName: 'Recipegroup'
            })
        
        res = await chai.request('http://localhost:3000')
            .post('/group')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send({
                groupName: 'AdminUserGroup'
            })

        res = await chai.request('http://localhost:3000')
            .get('/group')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)


        groups = res.body.groups;

        deletegroupId = groups[0].id;
        leavergroupId = groups[1].id;
        
    });

    it('should successfully join groups', async () => {

        for (var i = 0; i < 3; i++) {

            res = await chai.request('http://localhost:3000')
                .patch('/group/join/')
                .set('content-type', 'application/json')
                .set('Authorization', idTokenUser)
                .send({
                    groupCode: groups[i].group_code
                })

            expect(res).status(200);
        }

        res = await chai.request('http://localhost:3000')
            .patch('/group/join/')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser2)
            .send({
                groupCode: groups[3].group_code
            })

        expect(res).status(200);

    })

    it('should successfully leave group, oldest member should be made admin', async () => {


            res = await chai.request('http://localhost:3000')
                .patch('/group/leave/' + leavergroupId)
                .set('content-type', 'application/json')
                .set('Authorization', idTokenAd)
    
            expect(res).status(200);
        }
    );

    it('should fail deleting group as non-admin', async () => {
            
        res = await chai.request('http://localhost:3000')
            .delete('/group/' + deletegroupId)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)

        expect(res).status(401);
    }
    );

    it('should successfully delete group as admin', async () => {
            
        res = await chai.request('http://localhost:3000')
            .delete('/group/' + deletegroupId)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)

        expect(res).status(200);
    }
    );

    it('should successfully get group, oldest member should be made admin and changes should be made.', async () => {
        res = await chai.request('http://localhost:3000')
        .get('/group/' + leavergroupId)
        .set('content-type', 'application/json')
        .set('Authorization', idTokenUser)


        console.log(res.body.group.members)
        expect(res.body.group.members[0].is_admin).to.equal(true);
    });
});

