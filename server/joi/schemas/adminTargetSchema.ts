import Joi from 'joi';

const adminTargetSchema = Joi.object({
    id: Joi.number().positive(),
    user_id: Joi.string().required(),
    target_id: Joi.string(),
    group_id: Joi.string().required()
});

export default adminTargetSchema