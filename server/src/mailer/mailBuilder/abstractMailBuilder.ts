import nodemailer = require("nodemailer");

/**
 * @class AbstractMailBuilder
 * @description This class is used to build a mail.
 * @exports AbstractMailBuilder
 * @abstract
 * @version 0.1.1
 * @abstract
 * @requires nodemailer
 */
export default abstract class AbstractMailBuilder {
  protected sender: string;
  protected receiver: string;
  protected subject: string;
  protected html: string;
}
