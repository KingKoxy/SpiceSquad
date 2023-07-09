import Joi from 'joi'
import { userId } from './generalSchema'

const groupName = Joi.string().max(32)
const groupCode = Joi.string()

export const GroupCreateSchema = Joi.object().keys({
  groupName: groupName.required(),
  userId: userId,
})

export const GroupDeleteSchema = Joi.object().keys({
  userId: userId,
})

export const GroupUpdateSchema = Joi.object().keys({
  groupName: groupName,
  userId: userId,
})

export const GroupJoinSchema = Joi.object().keys({
  groupCode: groupCode,
  userId: userId,
})

export const GroupLeaveSchema = Joi.object().keys({
  userId: userId,
})

export const GroupGetAllSchema = Joi.object().keys({
  userId: userId,
})

export const GroupGetIdSchema = Joi.object().keys({
  userId: userId,
})
