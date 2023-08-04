import chai, { expect, use } from 'chai';
import Server from '../src/server';
import chaiHttp from 'chai-http'; // Import chai-http module

require('./groupRouter.test')
chai.use(chaiHttp); // Extend chai with chai-http plugin

const icon = [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 30, 0, 0, 0, 30, 8, 6, 0, 0, 0, 59, 48, 174, 162, 0, 0, 0, 9, 112, 72, 89, 115, 0, 0, 11, 19, 0, 0, 11, 19, 1, 0, 154, 156, 24, 0, 0, 1, 229, 73, 68, 65, 84, 120, 156, 237, 150, 59, 72, 92, 65, 20, 134, 191, 136, 68, 68, 86, 124, 16, 193, 222, 77, 74, 43, 87, 144, 88, 137, 16, 8, 104, 103, 147, 222, 194, 66, 83, 37, 16, 136, 141, 79, 216, 42, 4, 21, 172, 4, 13, 219, 164, 16, 27, 11, 65, 212, 77, 162, 176, 154, 4, 177, 88, 176, 72, 17, 92, 52, 209, 4, 65, 87, 13, 187, 174, 140, 156, 133, 97, 185, 119, 103, 230, 114, 37, 141, 63, 76, 113, 231, 252, 103, 62, 102, 230, 220, 153, 129, 123, 133, 167, 42, 96, 11, 88, 15, 113, 204, 91, 213, 2, 51, 64, 6, 72, 122, 196, 95, 1, 5, 96, 39, 108, 240, 178, 12, 172, 218, 134, 71, 124, 91, 98, 61, 65, 6, 95, 5, 190, 3, 177, 146, 254, 46, 25, 244, 20, 104, 209, 250, 31, 1, 239, 129, 31, 192, 181, 120, 166, 129, 38, 87, 112, 86, 146, 115, 192, 60, 208, 9, 68, 100, 105, 85, 255, 176, 230, 173, 3, 246, 181, 85, 208, 91, 26, 104, 116, 1, 31, 248, 12, 164, 218, 47, 160, 94, 243, 78, 150, 241, 22, 128, 113, 23, 240, 39, 109, 102, 113, 153, 209, 165, 236, 95, 107, 137, 247, 171, 1, 156, 118, 1, 199, 37, 105, 206, 194, 251, 215, 0, 206, 186, 128, 219, 37, 233, 204, 176, 71, 17, 3, 180, 0, 156, 227, 168, 207, 146, 56, 81, 198, 19, 181, 0, 31, 186, 130, 99, 82, 213, 255, 60, 246, 181, 168, 110, 11, 112, 138, 0, 122, 39, 201, 31, 125, 226, 47, 45, 192, 31, 130, 128, 155, 37, 249, 216, 39, 190, 96, 1, 30, 48, 65, 170, 229, 128, 80, 167, 214, 3, 233, 107, 144, 228, 63, 30, 254, 10, 224, 200, 2, 28, 53, 129, 223, 104, 230, 33, 169, 216, 81, 249, 94, 241, 240, 63, 181, 128, 110, 218, 92, 101, 197, 255, 49, 95, 146, 156, 151, 51, 186, 84, 9, 11, 240, 11, 19, 248, 185, 86, 129, 207, 128, 61, 224, 2, 248, 6, 244, 122, 248, 159, 72, 181, 151, 131, 238, 202, 118, 148, 213, 172, 152, 213, 114, 155, 164, 246, 127, 205, 0, 205, 201, 33, 100, 84, 74, 18, 58, 204, 86, 222, 90, 44, 241, 107, 44, 245, 91, 18, 76, 247, 103, 191, 5, 116, 10, 7, 93, 73, 210, 67, 159, 120, 165, 92, 28, 197, 75, 222, 171, 169, 216, 152, 246, 43, 90, 41, 233, 243, 140, 81, 106, 3, 190, 24, 102, 153, 9, 250, 212, 241, 210, 99, 96]

describe('RecipeRouter', async () => {
    let server = new Server()	;

    var idTokenAd : string;
    var idTokenUser : string;
    var recipeId : string;
    var res;

    it('should successfully create recipe', async () => {
        var res = await chai.request('http://localhost:3000')
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

        var res = await chai.request('http://localhost:3000')
            .post('/recipe/')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send(   {     
            "title": "Yo-gurt",
            "image": null,
            "duration": 30,
            "difficulty": "EASY",
            "ingredients": [
                {
                    "name": "Ingwer",
                    "icon": icon,
                    "amount": 2,
                    "unit": "kg"
                },
                {
                    "name": "Knoblauch",
                    "icon": icon,
                    "amount": 1,
                    "unit": "teaspoon"
                }
            ],
            "instructions": ".",
            "isVegetarian": true,
            "isVegan": false,
            "isGlutenFree": false,
            "isKosher": false,
            "isHalal": true,       //İnşallah stimmt das auch
            "isPrivate": false,
            "defaultPortionAmount": 2})

        console.log(res.body);
        expect(res).status(200);

        });

    it('should successfully get recipe', async () => {
        var res = await chai.request('http://localhost:3000')
            .get('/recipe')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)


        expect(res).status(200);
        expect(res.body.length).to.equal(1);

        recipeId = res.body[0].id;

        var res = await chai.request('http://localhost:3000')
            .get('/recipe')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)

        expect(res).status(200);
        expect(res.body.length).to.equal(1);
        expect(res.body[0].title).to.equal("Yo-gurt");

    });

    it('should fail updating recipe as non-author', async () => {
        var res = await chai.request('http://localhost:3000')
            .patch('/recipe/' + recipeId)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)
            .send({     
                "title": "Yo-gurt",
                "image": null,
                "duration": 30,
                "difficulty": "EASY",
                "ingredients": [
                    {
                        "name": "Ingwer",
                        "icon": icon,
                        "amount": 2,
                        "unit": "kg"
                    },
                    {
                        "name": "Knoblauch",
                        "icon": icon,
                        "amount": 1,
                        "unit": "teaspoon"
                    }
                ],
                "instructions": ".",
                "isVegetarian": true,
                "isVegan": false,
                "isGlutenFree": false,
                "isKosher": false,
                "isHalal": false,
                "isPrivate": true,
                "defaultPortionAmount": 2})


        expect(res).status(401);
    });

    it('should successfully update recipe as author', async () => {

        res = await chai.request('http://localhost:3000')
        .patch('/recipe/' + recipeId)
        .set('content-type', 'application/json')
        .set('Authorization', idTokenAd)
        .send({     
            "title": "Yo-gurt",
            "image": null,
            "duration": 30,
            "difficulty": "EASY",
            "ingredients": [
                {
                    "name": "Ingwer",
                    "icon": icon,
                    "amount": 2,
                    "unit": "kg"
                },
                {
                    "name": "Knoblauch",
                    "icon": icon,
                    "amount": 1,
                    "unit": "teaspoon"
                }
            ],
            "instructions": ".",
            "isVegetarian": true,
            "isVegan": false,
            "isGlutenFree": false,
            "isKosher": false,
            "isHalal": false,
            "isPrivate": true,
            "defaultPortionAmount": 2})

        expect(res).status(200);
    });

    it('should successfully get private recipe as author', async () => {

        res = await chai.request('http://localhost:3000')
        .get('/recipe')
        .set('content-type', 'application/json')
        .set('Authorization', idTokenAd)

        expect(res.body.length).to.equal(1);
        expect(res).status(200);
    })

    it('should fail getting private recipe as non-author', async () => {

        res = await chai.request('http://localhost:3000')
        .get('/recipe')
        .set('content-type', 'application/json')
        .set('Authorization', idTokenUser)

        expect(res).status(200);
        expect(res.body.length).to.equal(0);
    });

    it('should fail deleting recipe as non-author', async () => {

        res = await chai.request('http://localhost:3000')
        .delete('/recipe/' + recipeId)
        .set('content-type', 'application/json')
        .set('Authorization', idTokenUser)

        expect(res).status(401);
    });

    it('should successfully delete recipe as author', async () => {
            
            res = await chai.request('http://localhost:3000')
            .delete('/recipe/' + recipeId)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
    
            expect(res).status(200);
        }
    );

    it('should fail getting deleted recipe', async () => {
            
            res = await chai.request('http://localhost:3000')
            .get('/recipe')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
    
            expect(res).status(200);
            expect(res.body.length).to.equal(0);
        }
    );

    it('should succesfully set recipe as favorite', async () => {

        var res = await chai.request('http://localhost:3000')
            .post('/recipe/')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenAd)
            .send(   {     
            "title": "Yo-gurt",
            "image": null,
            "duration": 30,
            "difficulty": "EASY",
            "ingredients": [
                {
                    "name": "Ingwer",
                    "icon": icon,
                    "amount": 2,
                    "unit": "kg"
                },
                {
                    "name": "Knoblauch",
                    "icon": icon,
                    "amount": 1,
                    "unit": "teaspoon"
                }
            ],
            "instructions": ".",
            "isVegetarian": true,
            "isVegan": false,
            "isGlutenFree": false,
            "isKosher": false,
            "isHalal": true,       
            "isPrivate": false,
            "defaultPortionAmount": 2})

        
        res = await chai.request('http://localhost:3000')
            .get('/recipe')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)
        
        res = await chai.request('http://localhost:3000')
            .patch('/recipe/setFavorite/' + res.body[0].id)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)
            .send({
                "isFavorite": true
            })

        expect(res).status(200);

        res = await chai.request('http://localhost:3000')
            .get('/recipe')
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)

        expect(res).status(200);
        expect(res.body.length).to.equal(1);
        expect(res.body[0].isFavourite).to.equal(true);

        recipeId = res.body[0].id;
    })


    it('should succesfully report recipe', async () => {

        await chai.request('http://localhost:3000')
            .post('/recipe/report/' + recipeId)
            .set('content-type', 'application/json')
            .set('Authorization', idTokenUser)  //Das war gar nicht halal

        expect(res).status(200);
        
        
    })

});