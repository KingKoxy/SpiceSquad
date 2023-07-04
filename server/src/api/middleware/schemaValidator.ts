import express = require("express");
import abstractMiddleware from "./abstractMiddleware";
import joi = require("joi");

class SchemaValidator extends abstractMiddleware{

    constructor() {
        super();
    }

    public checkSchema(schema: joi.ObjectSchema<any>): express.RequestHandler {
    return (req: express.Request, res: express.Response, next: express.NextFunction) => {
        console.log(req.body);
        console.log("test");
        const { error } = schema.validate(req.body);
        if (error) {
            req.statusCode = 422;
            next(new Error(error.details[0].message));
            return;
        }
        next();
    }
  }
    
}

export default SchemaValidator;