import Joi from 'joi'
import { userName } from './generalSchema'

const email = Joi.string().email()
const password = Joi.string()
const refreshToken = Joi.string().required()

export const registerSchema = Joi.object()
  .keys({
    userName: userName.required(),
    email: email.required(),
    password: password.required(),
  })
  .unknown(true)

export const loginSchema = Joi.object()
  .keys({
    email: email.required(),
    password: password.required(),
  })
  .unknown(true)

export const resetPasswordSchema = Joi.object()
  .keys({
    email: email.required(),
  })
  .unknown(true)

//Specify the schema for the refreshToken route
export const refreshTokenSchema = Joi.object({
  refreshToken: refreshToken.required(),
}).unknown(true)

//Specify the schema for the logout route
export const logoutSchema = Joi.object({}).unknown(true)
