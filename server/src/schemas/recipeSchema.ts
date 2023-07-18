import Joi from 'joi'
import { userId } from './generalSchema'

const title = Joi.string()
const image = Joi.array().allow(null)
const duration = Joi.number().positive()
const difficulty = Joi.string().valid('EASY', 'MEDIUM', 'HARD')
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
    name: Joi.string(),
    icon: Joi.array(),
    amount: Joi.number().positive(),
    unit: Joi.string().max(16),
  }).unknown(true)
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
}).unknown(true);

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
}).unknown(true);

export const recipeGetAllSchema = Joi.object({
  userId: userId,
}).unknown(true);

export const recipeDeleteSchema = Joi.object({
  userId: userId,
}).unknown(true);

export const recipeSetFavorite = Joi.object().keys({
  userId: userId,
  isFavorite: isFavorite.required(),
}).unknown(true);

export const recipeReportSchema = Joi.object({}).unknown(true);
