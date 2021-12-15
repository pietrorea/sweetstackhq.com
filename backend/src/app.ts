import { config } from "dotenv";
config();

import cors from "cors"
import express from "express";
import { logger } from "./util/logger";
import pinoHttp from "pino-http";
import { sendMarketingEmail } from './controllers/marketingEmail';
import * as Sentry from '@sentry/node';

const app = express();

const dsn = process.env.SENTRY_DSN || '';
const environment = process.env.NODE_ENV || '';
const debug = environment !== 'production';
Sentry.init({ dsn, debug, environment });

// Sentry's handler must be the first middleware on the app
app.use(Sentry.Handlers.requestHandler());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(pinoHttp({ logger }));

if (process.env.NODE_ENV !== "production" && process.env.CORS) {
  const corsInstance = cors({origin: "*"});
  app.use(corsInstance);
  app.options("*", corsInstance);
}

// Endpoints

app.get("/site/api/v1/health", (req, res) => {
  res.send({ message: "OK" });
});

app.get('/site/api/v1/sentry-debug', (req, res) => {
  throw new Error("Test error. Sentry verification.");
});

app.post("/site/api/v1/contact", (req, res) => {
  const data = req.body;
  sendMarketingEmail(data, function(err: { stack: any; }, data: any) {
    if (err) {
      console.log(err, err.stack);
      res.sendStatus(400);
    } else {
      console.log(data); 
      res.sendStatus(200);
    }
  });
});

app.use(Sentry.Handlers.errorHandler());

export { app };