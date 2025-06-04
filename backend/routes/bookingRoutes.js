import express from "express";
import {
  getAllBookings,
  getBookingById,
  createBooking,
  updateBookingStatus,
  deleteBooking,
} from "../controllers/bookingController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.get("/", authMiddleware(["admin", "customer"]), getAllBookings);
router.get("/:id", authMiddleware(["admin", "customer"]), getBookingById);

// Customer wajib login untuk create booking
router.post("/", authMiddleware("customer"), createBooking);

// Update status booking, misal hanya admin boleh update status
router.put("/:id", authMiddleware("admin"), updateBookingStatus);
router.delete("/:id", authMiddleware("admin"), deleteBooking);

export default router;
