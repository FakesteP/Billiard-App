import Table from "../models/Table.js";
import Booking from "../models/Booking.js";
import User from "../models/Users.js";
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

// Get recent activities for admin
export const getAdminActivities = async (req, res) => {
  try {
    const activities = [];

    // Get recent bookings with user and table info
    const recentBookings = await Booking.findAll({
      limit: 5,
      order: [["tanggal_dibuat", "DESC"]],
      include: [
        {
          model: User,
          attributes: ["username", "role"],
        },
        {
          model: Table,
          attributes: ["name"],
        },
      ],
    });

    recentBookings.forEach((booking) => {
      const timeAgo = getTimeAgo(booking.tanggal_dibuat);
      activities.push({
        icon: "event_available",
        title: `Booking ${booking.status}`,
        subtitle: `${booking.User.username} - ${booking.Table.name}`,
        time: timeAgo,
        type: "booking",
      });
    });

    // Get recent completed bookings
    const completedBookings = await Booking.findAll({
      where: { status: "completed" },
      limit: 3,
      order: [["tanggal_diperbarui", "DESC"]],
      include: [
        {
          model: User,
          attributes: ["username"],
        },
        {
          model: Table,
          attributes: ["name"],
        },
      ],
    });

    completedBookings.forEach((booking) => {
      const timeAgo = getTimeAgo(booking.tanggal_diperbarui);
      activities.push({
        icon: "sports_bar",
        title: "Session completed",
        subtitle: `${booking.User.username} - ${booking.Table.name}`,
        time: timeAgo,
        type: "completed",
      });
    });

    // Sort all activities by time
    activities.sort((a, b) => new Date(b.time) - new Date(a.time));

    res.json({
      activities: activities.slice(0, 5), // Return top 5 activities
    });
  } catch (error) {
    console.error("Error getting admin activities:", error);
    res.status(500).json({ message: error.message });
  }
};

// Get recent activities for user
export const getUserActivities = async (req, res) => {
  try {
    const userId = req.user.id;
    const activities = [];

    // Get user's recent bookings
    const userBookings = await Booking.findAll({
      where: { user_id: userId },
      limit: 5,
      order: [["tanggal_dibuat", "DESC"]],
      include: [
        {
          model: Table,
          attributes: ["name"],
        },
      ],
    });

    userBookings.forEach((booking) => {
      const timeAgo = getTimeAgo(booking.tanggal_dibuat);
      let title = "";
      let icon = "";

      switch (booking.status) {
        case "pending":
          title = "Booking confirmed";
          icon = "event_available";
          break;
        case "completed":
          title = "Session completed";
          icon = "sports_bar";
          break;
        case "cancelled":
          title = "Booking cancelled";
          icon = "cancel";
          break;
        default:
          title = "Booking created";
          icon = "event";
      }

      activities.push({
        icon: icon,
        title: title,
        subtitle: `${booking.Table.name} - ${booking.date}`,
        time: timeAgo,
        type: booking.status,
      });
    });

    // Add achievement for completed sessions
    const completedCount = await Booking.count({
      where: {
        user_id: userId,
        status: "completed",
      },
    });

    if (completedCount >= 10) {
      activities.push({
        icon: "people",
        title: "Achievement unlocked",
        subtitle: `Played ${completedCount}+ sessions`,
        time: "Recently",
        type: "achievement",
      });
    }

    res.json({
      activities: activities.slice(0, 5), // Return top 5 activities
    });
  } catch (error) {
    console.error("Error getting user activities:", error);
    res.status(500).json({ message: error.message });
  }
};

// Helper function to calculate time ago
function getTimeAgo(date) {
  const now = new Date();
  const diffMs = now - new Date(date);
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMs / 3600000);
  const diffDays = Math.floor(diffMs / 86400000);

  if (diffMins < 60) {
    return `${diffMins} minutes ago`;
  } else if (diffHours < 24) {
    return `${diffHours} hours ago`;
  } else {
    return `${diffDays} days ago`;
  }
}
