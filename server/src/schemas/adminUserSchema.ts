import Joi from 'joi'
import { userId } from './generalSchema'

const targetId = Joi.string().guid()
const groupId = Joi.string().guid()
const recipeId = Joi.string().guid()
const censored = Joi.boolean()

export const makeAdminSchema = Joi.object().keys({
  userId: userId.required(),
}).unknown(true);

export const removeAdminSchema = Joi.object().keys({
  userId: userId.required(),
}).unknown(true);

export const kickUser = Joi.object().keys({
  userId: userId.required(),
}).unknown(true);

export const banUser = Joi.object().keys({
  userId: userId.required(),
}).unknown(true);

export const setCensored = Joi.object().keys({
  censored: censored.required(),
}).unknown(true);
