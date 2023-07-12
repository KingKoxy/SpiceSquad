import Joi from 'joi'
import { userId } from './generalSchema'

export const ingredientNameGetSchema = Joi.object().keys({}).unknown(true);

export const ingredientIconGetSchema = Joi.object().keys({}).unknown(true);
