import express from "express";
import {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
} from "../controllers/userController.js";

const router = express.Router();

// List user
router.get("/", getAllUsers);

// Get user by ID
router.get("/:id", getUserById);

// Edit user
router.put("/:id", updateUser);

// Delete user
router.delete("/:id", deleteUser);

export default router;

// Pastikan file ini di-import di app.js/server.js dengan:
// import userRoutes from "./routes/userRoutes.js";
// app.use("/users", userRoutes);
