import fs = require('fs')
import abstractMailBuilder from './abstractMailBuilder'
import nodemailer = require('nodemailer')

/**
 * @class ReportMailBuilder
 * @description This class is used to build report mail.
 * @exports ReportMailBuilder
 * @version 0.0.1
 * @extends AbstractMailBuilder
 * @requires fs
 * @requires AbstractMailBuilder
 * @requires nodemailer
 */
export default class ReportMailBuilder extends abstractMailBuilder {
  private htmlPath = './src/mailer/templates/reportMail.html'
  private htmlText = fs.readFileSync(this.htmlPath, 'utf8')

  /**
   * @constructor
   * @description This constructor initializes the report mail.
   * @memberof ReportMailBuilder
   * @instance
   * @returns {void}
   */
  constructor() {
    super()
    this.sender = process.env.EMAIL_USER
    this.subject = 'Report'
  }

  /**
   * @function buildMail
   * @description This function builds the report mail.
   * @memberof ReportMailBuilder
   * @instance
   * @param {string} receiver - The receiver of the mail.
   * @param {string} adminUsername - The username of the admin.
   * @param {string} recipeTitle - The title of the recipe.
   * @param {string} reportedUsername - The username of the reported user.
   * @param {string} groupName - The name of the group.
   * @returns {nodemailer.SendMailOptions} The mail options.
   */
  public buildMail(
    receiver: string,
    adminUsername: string,
    recipeTitle: string,
    reportedUsername: string,
    groupName: string
  ): nodemailer.SendMailOptions {
    this.receiver = receiver
    this.html = this.htmlText
      .replace('{{adminUsername}}', adminUsername)
      .replace('{{recipeTitle}}', recipeTitle)
      .replace('{{reportedUsername}}', reportedUsername)
      .replace('{{groupName}}', groupName)

    return {
      from: this.sender,
      to: this.receiver,
      subject: this.subject,
      html: this.html,
    }
  }
}
