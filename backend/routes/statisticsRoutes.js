import express from "express";
import {
  getDashboardStats,
  getUserStats,
  getAvailableTablesStats,
} from "../controllers/statisticsController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";

const router = express.Router();

// Public endpoint for general dashboard stats
router.get("/dashboard", getDashboardStats);

// Protected endpoint for user-specific stats
router.get("/user", authMiddleware(), getUserStats);

// Public endpoint for available tables stats
router.get("/tables", getAvailableTablesStats);

export default router;
