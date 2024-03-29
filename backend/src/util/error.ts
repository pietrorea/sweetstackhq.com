import pino from "pino";

import { logger } from "./logger";

export const handle = pino.final(logger, (err, finalLogger) => {
  finalLogger.fatal(err);
  process.exitCode = 1;
  process.kill(process.pid, "SIGTERM");
});