import express = require('express')

interface AuthenticatedRequest extends express.Request {
    userId?: string
}

export { AuthenticatedRequest }
