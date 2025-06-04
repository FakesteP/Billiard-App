import db from "./config/database.js";
import app from "./app.js";
import dotenv from "dotenv";

const PORT = process.env.PORT || 5000;
dotenv.config();

try {
  await db.authenticate();
  console.log("DB connected...");

  await db.sync(); // gunakan { alter: true } saat dev

  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
} catch (err) {
  console.error("DB connection error:", err);
}
