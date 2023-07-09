import Joi from 'joi'
import { userName } from './generalSchema'

const profileImage = Joi.string()
const email = Joi.string().email()

export const userDeleteSchema = Joi.object({})

export const userPatchSchema = Joi.object().keys({
  userName: userName,
  profileImage: profileImage,
  email: email,
})

//Specify the schema for getUserByToken
export const getUserByTokenSchema = Joi.object({
  user: Joi.object({}).options({ allowUnknown: true }),
})
