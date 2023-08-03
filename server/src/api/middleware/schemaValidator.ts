import express = require('express')
import AbstractMiddleware from './abstractMiddleware'
import joi = require('joi')

/**
 * @class SchemaValidator
 * @description This class is used to validate the schema of a request.
 * @exports SchemaValidator
 * @version 1.0.0
 * @extends AbstractMiddleware
 */
export default class SchemaValidator extends AbstractMiddleware {
  /**
   * @constructor: This constructor initializes the schema validator.
   * @memberof SchemaValidator
   */
  constructor() {
    super()
  }

  /**
   * @function checkSchema
   * @description This function checks whether the request conforms to the required schema.
   * @memberof SchemaValidator
   * @param {joi.ObjectSchema<any>} schema - The schema to check.
   * @returns {express.RequestHandler}
   * @public
   */
  public checkSchema(schema: joi.ObjectSchema<any>): express.RequestHandler {
    return (req: express.Request, res: express.Response, next: express.NextFunction) => {
      const { error } = schema.validate(req.body)
      if (error) {
        req.statusCode = 422
        next(new Error(error.details[0].message))
        return
      }
      next()
    }
  }
}
