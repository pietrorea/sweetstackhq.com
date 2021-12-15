import { handle } from "./util/error";
import { app } from "./app";
import { logger } from "./util/logger";

process.on("unhandledRejection", (err) => {
  throw err;
});

process.on("uncaughtException", (err) => {
  handle(err);
});

app.listen(process.env.PORT || 3000, () => {
  logger.info(
    `started server on :${process.env.PORT || 3000} in ${
      process.env.NODE_ENV
    } mode`
  );
});
  