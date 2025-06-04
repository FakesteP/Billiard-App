import { Sequelize } from "sequelize";
import db from "../config/database.js";

const Table = db.define(
  "tables",
  {
    id: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    status: {
      type: Sequelize.ENUM("available", "broken", "reserved"),
      defaultValue: "available",
      allowNull: false,
    },
    image_url: {
      type: Sequelize.STRING,
      allowNull: false,
      validate: {
        isUrl: true,
      },
    },
  },
  {
    freezeTableName: true,
    createdAt: "tanggal_dibuat",
    updatedAt: "tanggal_diperbarui",
  }
);

export default Table;
