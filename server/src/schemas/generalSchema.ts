import Joi from 'joi'

export const userName = Joi.string().max(32)
