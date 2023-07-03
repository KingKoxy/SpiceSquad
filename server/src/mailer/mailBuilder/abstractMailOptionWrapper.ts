import nodemailer = require("nodemailer");
abstract class AbstractMailWrapper {
  protected sender: string;
  protected receiver: string;
  protected subject: string;
  protected html: string;
}

export default AbstractMailWrapper;
