import express = require("express");
import abstractMiddleware from "./abstractMiddleware";
import joi = require("joi");

/**
 * @class SchemaValidator
 * @description This class is used to validate the schema of a request.
 * @exports SchemaValidator
 * @version 1.0.0
 * @extends abstractMiddleware
 */
export default class SchemaValidator extends abstractMiddleware{

    /**
     * @constructor: This constructor initializes the schema validator.
     * @memberof SchemaValidator
     */
    constructor() {
        super();
    }

    /**
     * @function checkSchema
     * @description This function checks the schema of a request.
     * @memberof SchemaValidator
     * @param {joi.ObjectSchema<any>} schema - The schema to check.
     * @returns {express.RequestHandler}
     * @public
     */
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