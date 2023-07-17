import Joi from 'joi'
import { userName } from './generalSchema'

const profileImage = Joi.string().allow(null)
const email = Joi.string().email()
const token = Joi.string().required()

export const userDeleteSchema = Joi.object({}).unknown(true);

export const userPatchSchema = Joi.object().keys({
  userName: userName,
  profileImage: profileImage,
  email: email,
}).unknown(true);

//Specify the schema for getUserByToken
export const getUserByTokenSchema = Joi.object({}).unknown(true);