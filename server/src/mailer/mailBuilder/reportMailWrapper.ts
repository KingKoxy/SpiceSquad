import fs = require("fs");
import abstractMailWrapper from "./abstractMailOptionWrapper";
import nodemailer = require("nodemailer");

class ReportMailWrapper extends abstractMailWrapper {
  private htmlPath: string = "./src/mailer/templates/reportMail.html";
  private htmlText: string = fs.readFileSync(this.htmlPath, "utf8");

  constructor() {
    super();
    this.sender = process.env.EMAIL_USER;
    this.subject = "Report";
  }

  public buildMail(
    receiver: string,
    adminUsername: string,
    recipeTitle: string,
    reportedUsername: string,
    groupName: string
  ): nodemailer.SendMailOptions {
    this.receiver = receiver;
    this.html = this.htmlText
      .replace("{{adminUsername}}", adminUsername)
      .replace("{{recipeTitle}}", recipeTitle)
      .replace("{{reportedUsername}}", reportedUsername)
      .replace("{{groupName}}", groupName);

    return {
      from: this.sender,
      to: this.receiver,
      subject: this.subject,
      html: this.html,
    };
  }
}

export default ReportMailWrapper;
