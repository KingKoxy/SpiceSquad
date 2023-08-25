import Joi from 'joi'

const censored = Joi.boolean()

export const makeAdminSchema = Joi.object()
  .keys({
  })
  .unknown(true)

export const removeAdminSchema = Joi.object()
  .keys({
  })
  .unknown(true)

export const kickUser = Joi.object()
  .keys({
  })
  .unknown(true)

export const banUser = Joi.object()
  .keys({
  })
  .unknown(true)

export const setCensored = Joi.object()
  .keys({
    censored: censored.required(),
  })
  .unknown(true)
