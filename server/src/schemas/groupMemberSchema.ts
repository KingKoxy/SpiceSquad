import Joi from 'joi'

const GroupMemberSchema = Joi.object({
    id: Joi.number().positive(),
    user_id: Joi.string().required(),
    group_id: Joi.string().required(),
})

export default GroupMemberSchema
