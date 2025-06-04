import express from "express";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";
import tableRoutes from "./routes/tableRoutes.js";
import bookingRoutes from "./routes/bookingRoutes.js";
import { errorHandler } from "./middlewares/errorHandler.js";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/auth", authRoutes);
app.use("/tables", tableRoutes);
app.use("/bookings", bookingRoutes);

// Letakkan error handler paling bawah setelah route
app.use(errorHandler);

export default app;
