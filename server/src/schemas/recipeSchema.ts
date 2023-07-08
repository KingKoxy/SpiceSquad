import Joi from 'joi'

const title = Joi.string()
const image = Joi.string()
const duration = Joi.number().positive()
const difficulty = Joi.string()
const instructions = Joi.string()
const isVegetarian = Joi.boolean()
const isVegan = Joi.boolean()
const isGluten_free = Joi.boolean()
const isKosher = Joi.boolean()
const isHalal = Joi.boolean()
const isPrivate = Joi.boolean()
const defaultPortions = Joi.number().positive()
const userId = Joi.string()

const ingredients = Joi.array().items(
    Joi.object({
        name: Joi.string(),
        iconName: Joi.string(),
        amount: Joi.number().positive(),
        unit: Joi.string(),
        recipeId: Joi.number().positive(),
    })
)

const isFavorite = Joi.boolean()

export const recipeCreateSchema = Joi.object().keys({
    title: title.required(),
    image: image.required(),
    duration: duration.required(),
    difficulty: difficulty.required(),
    instructions: instructions.required(),
    isVegetarian: isVegetarian.required(),
    isVegan: isVegan.required(),
    isGlutenFree: isGluten_free.required(),
    isKosher: isKosher.required(),
    isHalal: isHalal.required(),
    isPrivate: isPrivate.required(),
    defaultPortions: defaultPortions.required(),
    userId: userId.required(),
    ingredients: ingredients,
})

export const recipeGetAllSchema = Joi.object({
    userId: userId.required(),
})

export const recipeDeleteSchema = Joi.object({})

export const recipeUpdateSchema = Joi.object({
    title: title,
    image: image,
    duration: duration,
    difficulty: difficulty,
    instructions: instructions,
    isVegetarian: isVegetarian,
    isVegan: isVegan,
    isGlutenFree: isGluten_free,
    isKosher: isKosher,
    isHalal: isHalal,
    isPrivate: isPrivate,
    defaultPortions: defaultPortions,
    userId: userId,
    ingredients: ingredients,
})

export const recipeSetFavorite = Joi.object().keys({
    isFavorite: isFavorite.required(),
})

export const recipeReportSchema = Joi.object({})
