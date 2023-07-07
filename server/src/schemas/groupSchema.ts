import Joi from 'joi';

const groupName = Joi.string();
const userId = Joi.string();

export const GroupCreateSchema = Joi.object().keys({
    groupName: groupName.required(),
    userId: userId
});

export const GroupDeleteSchema = Joi.object({
    userId: userId,
});

export const GroupUpdateSchema = Joi.object({
    groupName: groupName,
});

export const GroupJoinSchema = Joi.object({
    userId: userId,
    groupId: Joi.string().required()
});

export const GroupLeaveSchema = Joi.object({});

export const GroupGetAllSchema = Joi.object({});


