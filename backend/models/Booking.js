import { Sequelize } from "sequelize";
import db from "../config/database.js";
import User from "./User.js";
import Table from "./Table.js";

const Booking = db.define(
  "bookings",
  {
    id: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    user_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: User,
        key: "id",
      },
    },
    table_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: Table,
        key: "id",
      },
    },
    date: {
      type: Sequelize.DATEONLY,
      allowNull: false,
    },
    start_time: {
      type: Sequelize.TIME,
      allowNull: false,
    },
    end_time: {
      type: Sequelize.TIME,
      allowNull: false,
    },
    status: {
      type: Sequelize.ENUM("pending", "cancelled", "completed"),
      defaultValue: "pending",
      allowNull: false,
    },
  },
  {
    freezeTableName: true,
    createdAt: "tanggal_dibuat",
    updatedAt: "tanggal_diperbarui",
  }
);

// Relasi
User.hasMany(Booking, { foreignKey: "user_id" });
Booking.belongsTo(User, { foreignKey: "user_id" });

Table.hasMany(Booking, { foreignKey: "table_id" });
Booking.belongsTo(Table, { foreignKey: "table_id" });

export default Booking;
