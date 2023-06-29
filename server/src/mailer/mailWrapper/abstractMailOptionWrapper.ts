import nodemailer = require('nodemailer');
abstract class abstractMailWrapper {

    protected sender: string;
    protected receiver: string;
    protected subject: string;
    protected html: string;

    /*constructor(from: string, to: string, subject: string, html:string) {
        this.from = from;
        this.to = to;
        this.subject = subject;
        this.html = html;
    }*/

}

export default abstractMailWrapper;