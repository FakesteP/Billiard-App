import Booking from "../models/Booking.js";
import Table from "../models/Table.js";
import User from "../models/user.js";
import { Op } from "sequelize";

// Get all bookings
export const getAllBookings = async (req, res) => {
  try {
    const bookings = await Booking.findAll({
      include: [User, Table],
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get booking by ID
export const getBookingById = async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id, {
      include: [User, Table],
    });
    if (!booking) return res.status(404).json({ message: "Booking not found" });
    res.json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const createBooking = async (req, res) => {
  try {
    const { user_id, table_id, date, start_time, end_time } = req.body;

    // Cek konflik booking pada waktu yang sama di meja itu
    const conflict = await Booking.findOne({
      where: {
        table_id,
        date,
        [Op.or]: [
          {
            start_time: { [Op.between]: [start_time, end_time] },
          },
          {
            end_time: { [Op.between]: [start_time, end_time] },
          },
          {
            [Op.and]: [
              { start_time: { [Op.lte]: start_time } },
              { end_time: { [Op.gte]: end_time } },
            ],
          },
        ],
      },
    });

    if (conflict) {
      return res
        .status(409)
        .json({ message: "Table already booked at this time" });
    }

    // Booking dibuat karena tidak ada konflik
    const booking = await Booking.create({
      user_id,
      table_id,
      date,
      start_time,
      end_time,
      status: "pending", // Status awal booking
    });

    // Update status meja jadi 'booked'
    const table = await Table.findByPk(table_id);
    if (table) {
      table.status = "reserved";
      await table.save();
    }

    res.status(201).json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update booking status (optional: cancel, complete)
export const updateBookingStatus = async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id);
    if (!booking) return res.status(404).json({ message: "Booking not found" });

    const newStatus = req.body.status || booking.status;
    booking.status = newStatus;
    await booking.save();

    // Cari meja terkait
    const table = await Table.findByPk(booking.table_id);
    if (!table) return res.status(404).json({ message: "Table not found" });

    // Update status meja sesuai status booking
    if (newStatus === "completed" || newStatus === "cancelled") {
      table.status = "available";
    } else if (newStatus === "pending" || newStatus === "pending") {
      table.status = "pending";
    }
    await table.save();

    // Jika status "completed", hitung durasi dan tambahkan poin ke user
    if (newStatus === "completed") {
      // Ambil user terkait
      const user = await User.findByPk(booking.user_id);
      if (!user) return res.status(404).json({ message: "User not found" });

      // Hitung durasi jam bermain
      // Asumsi start_time & end_time disimpan sebagai string 'HH:mm:ss' atau Date objek
      // Jika string, kita parsing ke Date dengan tanggal yang sama
      const date = booking.date; // misal '2025-05-29'
      const startTimeStr = booking.start_time; // misal '14:00:00'
      const endTimeStr = booking.end_time; // misal '16:30:00'

      const startDateTime = new Date(`${date}T${startTimeStr}`);
      const endDateTime = new Date(`${date}T${endTimeStr}`);

      let diffMs = endDateTime - startDateTime; // selisih dalam milidetik
      if (diffMs < 0) diffMs = 0; // jaga jaga

      const diffHours = Math.floor(diffMs / (1000 * 60 * 60)); // jam bulat ke bawah

      if (diffHours > 0) {
        user.point = (user.point || 0) + diffHours;
        await user.save();
      }
    }

    res.json({ message: "Booking and table status updated", booking, table });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete booking
export const deleteBooking = async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id);
    if (!booking) return res.status(404).json({ message: "Booking not found" });

    await booking.destroy();
    res.json({ message: "Booking deleted" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
