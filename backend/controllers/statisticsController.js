import Table from "../models/Table.js";
import Booking from "../models/Booking.js";
import { Op, Sequelize } from "sequelize";

// Get statistics for dashboard
export const getDashboardStats = async (req, res) => {
  try {
    // Get available tables count
    const availableTables = await Table.count({
      where: {
        status: "available",
      },
    });

    // Get total tables count
    const totalTables = await Table.count();

    // Get today's bookings count
    const today = new Date();
    const todayStr = today.toISOString().split("T")[0];

    const todayBookings = await Booking.count({
      where: {
        date: todayStr,
        status: { [Op.in]: ["pending", "completed"] },
      },
    });

    // Get active bookings count (pending status)
    const activeBookings = await Booking.count({
      where: {
        status: "pending",
      },
    });

    res.json({
      availableTables,
      totalTables,
      todayBookings,
      activeBookings,
    });
  } catch (error) {
    console.error("Error getting dashboard stats:", error);
    res.status(500).json({ message: error.message });
  }
};

// Get user-specific statistics
export const getUserStats = async (req, res) => {
  try {
    const userId = req.user.id;

    // Get user's total bookings count
    const totalBookings = await Booking.count({
      where: {
        user_id: userId,
      },
    });

    // Get user's active bookings count
    const activeBookings = await Booking.count({
      where: {
        user_id: userId,
        status: "pending",
      },
    });

    // Get user's completed bookings count
    const completedBookings = await Booking.count({
      where: {
        user_id: userId,
        status: "completed",
      },
    });

    // Calculate total hours played
    const completedBookingsList = await Booking.findAll({
      where: {
        user_id: userId,
        status: "completed",
      },
      attributes: ["start_time", "end_time"],
    });

    let totalHours = 0;
    completedBookingsList.forEach((booking) => {
      const startTime = new Date(`1970-01-01T${booking.start_time}`);
      const endTime = new Date(`1970-01-01T${booking.end_time}`);
      const diffInMs = endTime - startTime;
      const diffInHours = diffInMs / (1000 * 60 * 60);
      totalHours += diffInHours;
    });

    // Get this month's bookings count
    const currentMonth = new Date().getMonth() + 1;
    const currentYear = new Date().getFullYear();

    const thisMonthBookings = await Booking.count({
      where: {
        user_id: userId,
        [Op.and]: [
          Sequelize.where(
            Sequelize.fn("MONTH", Sequelize.col("date")),
            currentMonth
          ),
          Sequelize.where(
            Sequelize.fn("YEAR", Sequelize.col("date")),
            currentYear
          ),
        ],
      },
    });

    res.json({
      totalBookings,
      activeBookings,
      completedBookings,
      totalHours: Math.round(totalHours * 100) / 100, // Round to 2 decimal places
      thisMonthBookings,
    });
  } catch (error) {
    console.error("Error getting user stats:", error);
    res.status(500).json({ message: error.message });
  }
};

// Get available tables with real-time status
export const getAvailableTablesStats = async (req, res) => {
  try {
    const currentDate = new Date().toISOString().split("T")[0];
    const currentTime = new Date().toTimeString().split(" ")[0];

    // Get all tables
    const allTables = await Table.findAll();

    // Check which tables are currently booked
    const bookedTables = await Booking.findAll({
      where: {
        date: currentDate,
        status: "pending",
        start_time: { [Op.lte]: currentTime },
        end_time: { [Op.gte]: currentTime },
      },
      attributes: ["table_id"],
    });

    const bookedTableIds = bookedTables.map((booking) => booking.table_id);

    // Calculate available tables
    const availableTables = allTables.filter(
      (table) =>
        table.status === "available" && !bookedTableIds.includes(table.id)
    );

    res.json({
      totalTables: allTables.length,
      availableTables: availableTables.length,
      bookedTables: bookedTableIds.length,
      maintenanceTables: allTables.filter(
        (table) => table.status !== "available"
      ).length,
    });
  } catch (error) {
    console.error("Error getting available tables stats:", error);
    res.status(500).json({ message: error.message });
  }
};
