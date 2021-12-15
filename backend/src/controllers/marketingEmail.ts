import AWS from "aws-sdk";
import { defaultEmailSender } from "../util/constants";

const ses = new AWS.SES({
    accessKeyId: process.env.SES_ACCESS_KEY_ID,
    secretAccessKey: process.env.SES_SECRET_ACCESS_KEY,
    region: process.env.SES_REGION
});

interface SendEmailEvent {
    email: string
    firstName?: string
    lastName?: string
    phoneNumber?: string
    companyName: string
    otherInfo: string
};

export function sendMarketingEmail (event: SendEmailEvent, callback: any) {

    const messageBody = 'Email: ' + event.email +
    '\nFirst name: ' + event.firstName +
    '\nLast name: ' + event.lastName +
    '\nPhone number: ' + event.phoneNumber +
    '\nCompany name: ' + event.companyName +
    '\nOther info: ' + event.otherInfo

    const params = {
        Destination: {
            ToAddresses: [
              defaultEmailSender
            ]
        },
        Message: {
            Body: {
                Text: {
                    Data: messageBody,
                    Charset: 'UTF-8'
                }
            },
            Subject: {
                Data: 'Website Referral Form: ' + event.email,
                Charset: 'UTF-8'
            }
        },
        Source: defaultEmailSender
    };
    ses.sendEmail(params, callback);
}