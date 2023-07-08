import nodemailer = require('nodemailer')
import 'dotenv/config'

/**
 * @class MailSender
 * @description This class is used to send mails.
 * @exports MailSender
 * @version 0.0.1
 * @requires nodemailer
 * @requires dotenv
 * @requires .env
 */
class MailSender {
  private transporter: nodemailer.Transporter

  /**
   * @constructor
   * @description This constructor initializes the mail sender.
   * @memberof MailSender
   * @returns {void}
   * @protected
   */
  constructor() {
    this.transporter = nodemailer.createTransport({
      host: process.env.EMAIL_HOST,
      port: parseInt(process.env.EMAIL_PORT),
      secure: true,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
      },
    })
  }

  /**
   * @function sendMail
   * @description This function sends a mail.
   * @memberof MailSender
   * @param {nodemailer.SendMailOptions} mailOptions - The mail options.
   * @returns {Promise<void>} A promise.
   * @protected
   * @async
   * @throws {Error} The error which occured.
   */
  public async sendMail(mailOptions: nodemailer.SendMailOptions): Promise<void> {
    return new Promise((resolve, reject) => {
      this.transporter.sendMail(mailOptions, (error) => {
        if (error) {
          reject(error)
        }
        resolve()
      })
    })
  }
}

export default MailSender
