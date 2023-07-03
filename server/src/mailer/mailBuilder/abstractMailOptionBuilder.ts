import nodemailer = require("nodemailer");
abstract class AbstractMailBuilder {
  protected sender: string;
  protected receiver: string;
  protected subject: string;
  protected html: string;
}

export default AbstractMailBuilder;
