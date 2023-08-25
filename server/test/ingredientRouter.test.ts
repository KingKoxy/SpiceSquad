import chai, { expect, use } from 'chai';
import Server from '../src/server';
import chaiHttp from 'chai-http'; // Import chai-http module


chai.use(chaiHttp); // Extend chai with chai-http plugin

require('./adminUserRouter.test')

describe('IngredientRouter', () => {
    it('should successfully get ingredient names', async () => {
        var res = await chai.request('http://localhost:3000')
            .get('/ingredient/names')
            .set('content-type', 'application/json')
        
        expect(res).status(200);
        expect(res.body).to.have.lengthOf(324);
        expect(res.body[0].name).to.equal('Salz');
    });

    it('should successfully get ingredient by id', async () => {
        var res = await chai.request('http://localhost:3000')
            .get('/ingredient/icons')
            .set('content-type', 'application/json')
        
        expect(res).status(200);
        expect(res.body).to.have.lengthOf(51);
    });

    it('should successfully get ingredient icon by id', async () => {
        var res = await chai.request('http://localhost:3000')
            .get('/ingredient/icons/57497797-e16b-42f3-895b-2ef4d02ee6bc')
            .set('content-type', 'application/json')
        
        expect(res).status(200);
    });
});