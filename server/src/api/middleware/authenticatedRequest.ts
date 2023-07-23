import express = require('express')
import * as core from 'express-serve-static-core'

/**
 * @interface AuthenticatedRequest
 * @description This interface extends the express request interface with a userId property.
 * @exports AuthenticatedRequest
 * @version 1.0.0
 * @extends express.Request
 * @requires express
 */
interface AuthenticatedRequest<
  P = core.ParamsDictionary,
  ResBody = any,
  ReqBody = any,
  ReqQuery = core.Query,
  Locals extends Record<string, any> = Record<string, any>
> extends express.Request<P, ResBody, ReqBody, ReqQuery, Locals> {
  userId?: string
}

export default AuthenticatedRequest
