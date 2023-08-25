import Joi from 'joi'

const groupName = Joi.string().max(32)
const groupCode = Joi.string()

export const GroupCreateSchema = Joi.object()
  .keys({
    groupName: groupName.required(),
  })
  .unknown(true)

export const GroupDeleteSchema = Joi.object()
  .keys({
  })
  .unknown(true)

export const GroupUpdateSchema = Joi.object()
  .keys({
    groupName: groupName,
  })
  .unknown(true)

export const GroupJoinSchema = Joi.object()
  .keys({
    groupCode: groupCode,
  })
  .unknown(true)

export const GroupLeaveSchema = Joi.object()
  .keys({
  })
  .unknown(true)

export const GroupGetAllSchema = Joi.object()
  .keys({
  })
  .unknown(true)

export const GroupGetIdSchema = Joi.object()
  .keys({
  })
  .unknown(true)
