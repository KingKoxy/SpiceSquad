import express = require('express');
import AbstractController from './abstractController';


class RecipeController extends AbstractController{

    constructor() {
        super();
    }
    
    public async recipePost(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Handling POST requests to /recipes'
        });
        // TODO: Implement
    };
    
    public async recipeDelete(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Deleted recipe!'
        });
        // TODO: Implement
    };

    public async recipePatch(req: express.Request, res: express.Response): Promise<void>{
        res.status(200).json({
            message: 'Updated recipe!'
        });
        // TODO: Implement
    };
    
    public async recipesGetAllForUser(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Handling GET requests to /recipes'
        });
        // TODO: Implement
    }

    public async recipeReport(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Handling GET requests to /report'
        });
        // TODO: Implement
    }

    public async recipeSetFavorite(req: express.Request, res: express.Response): Promise<void> {
        res.status(200).json({
            message: 'Handling PATCH requests to /setFavorite'
        });
    }
    
}

export default RecipeController