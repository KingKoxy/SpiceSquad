import Joi from 'joi'

export const userId = Joi.string().guid()
export const userName = Joi.string().max(32)
