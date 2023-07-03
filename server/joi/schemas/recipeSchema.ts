import Joi from 'joi';

const RecipeSchema = Joi.object({
    id: Joi.number().positive(),
    title: Joi.string().required(),
    image: Joi.string(),
    duration: Joi.number().positive().required(),
    difficulty: Joi.string().required(),
    instructions: Joi.string().required(),
    is_vegetarian: Joi.boolean().required(),
    is_vegan: Joi.boolean().required(),
    is_gluten_free: Joi.boolean().required(),
    is_kosher: Joi.boolean().required(),
    is_halal: Joi.boolean().required(),
    is_private: Joi.boolean().required(),
    default_portions: Joi.number().positive().required(),
    user_id: Joi.string().required(),
    ingredients: Joi.array().items(Joi.object({
        id: Joi.number().positive(),
        name: Joi.string().required(),
        icon_name: Joi.string(),
        amount: Joi.number().positive(),
        unit: Joi.string(),
        recipe_id: Joi.number().positive()
    }))
  });

const RecipeSchemaUpdate = Joi.object({
    id: Joi.number().positive(),
    title: Joi.string(),
    image: Joi.string(),
    duration: Joi.number().positive(),
    difficulty: Joi.string(),
    instructions: Joi.string(),
    is_vegetarian: Joi.boolean(),
    is_vegan: Joi.boolean(),
    is_gluten_free: Joi.boolean(),
    is_kosher: Joi.boolean(),
    is_halal: Joi.boolean(),
    is_private: Joi.boolean(),
    default_portions: Joi.number().positive(),
    user_id: Joi.string(),
    ingredients: Joi.array().items(Joi.object({
        id: Joi.number().positive(),
        name: Joi.string(),
        icon_name: Joi.string(),
        amount: Joi.number().positive(),
        unit: Joi.string(),
        recipe_id: Joi.number().positive()
    }))
  });



export default RecipeSchema