import Joi from 'joi'
import { userId } from './generalSchema'

const targetId = Joi.string().guid()
const groupId = Joi.string().guid()
const recipeId = Joi.string().guid()

export const makeAdminSchema = Joi.object().keys({
  userId: userId.required(),
})

export const removeAdminSchema = Joi.object().keys({
  userId: userId.required(),
})

export const kickUser = Joi.object().keys({
  userId: userId.required(),
})

export const banUser = Joi.object().keys({
  userId: userId.required(),
})

export const setCensored = Joi.object().keys({
  userId: userId.required(),
})
