import AWS from "aws-sdk";
import { defaultEmailSender } from "./constants";

const ses = new AWS.SES({
  accessKeyId: process.env.SES_ACCESS_KEY_ID,
  secretAccessKey: process.env.SES_SECRET_ACCESS_KEY,
  region: process.env.SES_REGION
});

export function send(toEmailAddress: string, subject: string, body: string) {

  let toAddress = toEmailAddress;

  //TODO - undo after we get SES auth
  toAddress = defaultEmailSender;

  // if (process.env.NODE_ENV != 'production') {
  //   toAddress = defaultEmailSender;
  // }

  const params = {
      Destination: {
          ToAddresses: [
            toAddress
          ]
      },
      Message: {
          Body: {
              Text: {
                  Data: body,
                  Charset: 'UTF-8'
              }
          },
          Subject: {
              Data: subject,
              Charset: 'UTF-8'
          }
      },
      Source: defaultEmailSender
  };

  return ses.sendEmail(params).promise();
}