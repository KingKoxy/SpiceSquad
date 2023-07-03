import Joi from 'joi';

const GroupSchema = Joi.object({
    id: Joi.number().positive(),
    name: Joi.string().required(),
    user_id: Joi.string().required()
});

export default GroupSchema