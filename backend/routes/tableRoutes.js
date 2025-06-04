import express from "express";
import {
  updateTable,
  getAllTables,
  getTableById,
  createTable,
  deleteTable,
} from "../controllers/tableController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.get("/", getAllTables);
router.get("/:id", getTableById);

// Hanya admin yang bisa create, update, dan delete meja
router.post("/", authMiddleware("admin"), createTable);
router.put("/:id", authMiddleware("admin"), updateTable);
router.delete("/:id", authMiddleware("admin"), deleteTable);

export default router;
