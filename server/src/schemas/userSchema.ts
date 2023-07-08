import Joi from 'joi'

const userName = Joi.string()
const profileImage = Joi.string()

export const userDeleteSchema = Joi.object({})

export const userPatchSchema = Joi.object().keys({
    userName: userName,
    profileImage: profileImage,
})

//Specify the schema for userGet
export const userGetSchema = Joi.object({})
