import Joi from 'joi';

const CensoredRecipeSchema = Joi.object({
    id: Joi.number().positive(),
    user_id: Joi.string(),
    recipe_id: Joi.string().required(),
    group_id: Joi.string().required()
});

export default CensoredRecipeSchema