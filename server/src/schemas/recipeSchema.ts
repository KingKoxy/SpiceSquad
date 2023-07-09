import Joi from 'joi'
import { userId } from './generalSchema'

const title = Joi.string().max(64)
const image = Joi.array()
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

const ingredients = Joi.array().items(
  Joi.object({
    id: Joi.string(),
    name: Joi.string().max(32),
    icon: Joi.array(),
    amount: Joi.number().positive(),
    unit: Joi.string().max(16),
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
  defaultPortionAmount: defaultPortions.required(),
  ingredients: ingredients,
})

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
  defaultPortionAmount: defaultPortions,
  ingredients: Joi.array().items(
    Joi.object({
      id: Joi.string().required(),
      name: Joi.string().max(32),
      icon: Joi.array(),
      amount: Joi.number().positive(),
      unit: Joi.string().max(16),
    })
  ),
})

export const recipeGetAllSchema = Joi.object({
  userId: userId,
})

export const recipeDeleteSchema = Joi.object({
  userId: userId,
})

export const recipeSetFavorite = Joi.object().keys({
  userId: userId,
  isFavorite: isFavorite.required(),
})

export const recipeReportSchema = Joi.object({})
