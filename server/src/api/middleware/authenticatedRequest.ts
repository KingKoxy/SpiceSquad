import express = require('express')
import * as core from 'express-serve-static-core'

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
