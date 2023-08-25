import chai, { expect, use } from 'chai';
import Server from '../src/server';
import chaiHttp from 'chai-http'; // Import chai-http module


chai.use(chaiHttp); // Extend chai with chai-http plugin

require('./ingredientRouter.test')

const image = [137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,30,0,0,0,30,8,6,0,0,0,59,48,174,162,0,0,0,9,112,72,89,115,0,0,11,19,0,0,11,19,1,0,154,156,24,0,0,1,192,73,68,65,84,120,156,237,215,77,136,78,81,28,199,241,15,106,26,175,133,97,74,44,200,198,194,206,98,178,165,89,136,44,200,218,66,73,217,80,51,108,173,173,101,35,154,36,165,200,74,148,145,119,73,179,20,25,25,98,74,72,228,165,89,161,83,127,117,123,122,238,203,115,159,123,203,194,183,206,230,127,126,247,124,59,231,57,247,60,231,210,28,243,177,7,119,240,70,195,220,198,20,214,118,212,23,224,50,126,71,187,217,180,248,65,12,252,28,43,50,245,195,25,105,106,187,155,22,47,197,195,24,252,76,166,62,149,145,94,192,60,45,176,14,95,241,11,91,162,54,139,39,56,216,150,244,47,39,98,118,167,181,196,46,92,194,59,204,97,6,87,48,30,226,167,24,141,218,171,200,188,141,103,118,214,17,174,198,173,142,13,83,167,165,221,189,170,170,52,5,95,246,48,248,51,236,199,26,12,96,3,142,224,125,244,79,99,168,138,248,70,15,210,115,24,44,152,192,227,200,93,43,147,142,246,184,148,101,12,227,99,100,183,23,5,207,55,44,78,28,143,236,68,81,104,166,5,241,166,200,166,93,159,203,92,11,226,193,200,166,177,115,249,94,83,60,30,75,218,141,161,200,166,177,115,121,81,83,252,26,31,114,198,220,28,217,148,201,229,98,31,226,244,222,118,99,111,100,175,23,137,247,213,20,143,197,114,119,99,34,178,71,139,196,75,240,163,193,205,181,16,159,34,187,177,44,124,178,65,241,88,228,30,85,200,90,137,47,13,136,135,51,179,221,166,34,7,250,20,167,59,216,100,213,115,186,206,14,207,147,158,141,254,217,152,121,79,44,198,189,18,241,162,142,103,150,227,106,244,125,195,86,53,89,134,251,37,255,197,59,226,116,58,20,55,149,84,255,140,17,125,50,128,83,113,185,171,242,187,223,197,122,13,50,18,167,207,207,184,85,28,139,243,121,58,222,130,201,248,146,72,95,20,255,249,119,248,3,207,121,44,182,221,7,154,231,0,0,0,0,73,69,78,68,174,66,96,130]
const image1 = [138,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,30,0,0,0,30,8,6,0,0,0,59,48,174,162,0,0,0,9,112,72,89,115,0,0,11,19,0,0,11,19,1,0,154,156,24,0,0,1,192,73,68,65,84,120,156,237,215,77,136,78,81,28,199,241,15,106,26,175,133,97,74,44,200,198,194,206,98,178,165,89,136,44,200,218,66,73,217,80,51,108,173,173,101,35,154,36,165,200,74,148,145,119,73,179,20,25,25,98,74,72,228,165,89,161,83,127,117,123,122,238,203,115,159,123,203,194,183,206,230,127,126,247,124,59,231,57,247,60,231,210,28,243,177,7,119,240,70,195,220,198,20,214,118,212,23,224,50,126,71,187,217,180,248,65,12,252,28,43,50,245,195,25,105,106,187,155,22,47,197,195,24,252,76,166,62,149,145,94,192,60,45,176,14,95,241,11,91,162,54,139,39,56,216,150,244,47,39,98,118,167,181,196,46,92,194,59,204,97,6,87,48,30,226,167,24,141,218,171,200,188,141,103,118,214,17,174,198,173,142,13,83,167,165,221,189,170,170,52,5,95,246,48,248,51,236,199,26,12,96,3,142,224,125,244,79,99,168,138,248,70,15,210,115,24,44,152,192,227,200,93,43,147,142,246,184,148,101,12,227,99,100,183,23,5,207,55,44,78,28,143,236,68,81,104,166,5,241,166,200,166,93,159,203,92,11,226,193,200,166,177,115,249,94,83,60,30,75,218,141,161,200,166,177,115,121,81,83,252,26,31,114,198,220,28,217,148,201,229,98,31,226,244,222,118,99,111,100,175,23,137,247,213,20,143,197,114,119,99,34,178,71,139,196,75,240,163,193,205,181,16,159,34,187,177,44,124,178,65,241,88,228,30,85,200,90,137,47,13,136,135,51,179,221,166,34,7,250,20,167,59,216,100,213,115,186,206,14,207,147,158,141,254,217,152,121,79,44,198,189,18,241,162,142,103,150,227,106,244,125,195,86,53,89,134,251,37,255,197,59,226,116,58,20,55,149,84,255,140,17,125,50,128,83,113,185,171,242,187,223,197,122,13,50,18,167,207,207,184,85,28,139,243,121,58,222,130,201,248,146,72,95,20,255,249,119,248,3,207,121,44,182,221,7,154,231,0,0,0,0,73,69,78,68,174,66,96,130]

var idToken;
var res;
var imageid;

describe('imageRouter', () => {
    it('should post image', async () => {
        res = await chai.request('http://localhost:3000')
        .post('/auth/login')
        .set('content-type', 'application/json')
        .send({
          email: 'indila@mailbox.org',
          password: '12345678'
        })
        
        expect(res).status(200); 
        idToken = res.body.idToken;

        res = await chai.request('http://localhost:3000')
        .post('/image')
        .set('content-type', 'application/json')
        .set('Authorization', idToken)
        .send({
            image: image
        })

        imageid = res.body.id;
        expect(res).status(201);

        await setTimeout(() => {}, 1000);
    });   

    it('should successfully patch image', async () => {
        res = await chai.request('http://localhost:3000')
        .patch('/image/' + imageid)
        .set('content-type', 'application/json')
        .set('Authorization', idToken)
        .send({
            image: image1
        })
        console.log(res.body)
        expect(res).status(200);
    });
});