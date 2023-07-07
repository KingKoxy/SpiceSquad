import Joi from 'joi';


const userName = Joi.string();
const email = Joi.string().email();
const password = Joi.string();

export const registerSchema = Joi.object().keys({
    userName: userName.required(),
    email: email.required(),
    password: password.required(),
});

export const loginSchema = Joi.object().keys({
    email: email.required(),
    password: password.required(),
});

export const resetPasswordSchema = Joi.object().keys({
    email: email.required(),
});

//Specify the schema for getUserByToken
export const getUserByTokenSchema = Joi.object({
});

//Specify the schema for the refreshToken route
export const refreshTokenSchema = Joi.object({
});

//Specify the schema for the logout route
export const logoutSchema = Joi.object({
});


