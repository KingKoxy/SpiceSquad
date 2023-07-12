import Joi from 'joi'
import { userId } from './generalSchema'

const groupName = Joi.string().max(32)
const groupCode = Joi.string()

export const GroupCreateSchema = Joi.object().keys({
  groupName: groupName.required(),
  userId: userId,
}).unknown(true);

export const GroupDeleteSchema = Joi.object().keys({
  userId: userId,
}).unknown(true);

export const GroupUpdateSchema = Joi.object().keys({
  groupName: groupName,
  userId: userId,
}).unknown(true);

export const GroupJoinSchema = Joi.object().keys({
  groupCode: groupCode,
  userId: userId,
}).unknown(true);

export const GroupLeaveSchema = Joi.object().keys({
  userId: userId,
}).unknown(true);

export const GroupGetAllSchema = Joi.object().keys({
  userId: userId,
}).unknown(true);

export const GroupGetIdSchema = Joi.object().keys({
  userId: userId,
}).unknown(true);
