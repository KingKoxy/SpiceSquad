import Joi from 'joi'

const image = Joi.array()

export const imagePostSchema = Joi.object()
  .keys({
    image: image.required(),
  })
  .unknown(true)
export const imagePatchSchema = Joi.object()
  .keys({
    image: image.required(),
  })
  .unknown(true)

export const imageGetSchema = Joi.object().keys({}).unknown(true)
