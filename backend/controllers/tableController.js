import Table from "../models/Table.js";

// Get all tables
export const getAllTables = async (req, res) => {
  try {
    const tables = await Table.findAll();
    res.json(tables);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get table by ID
export const getTableById = async (req, res) => {
  try {
    const table = await Table.findByPk(req.params.id);
    if (!table) return res.status(404).json({ message: "Table not found" });
    res.json(table);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create new table
export const createTable = async (req, res) => {
  try {
    const { name, status, image_url } = req.body;
    const table = await Table.create({ name, status, image_url });
    res.status(201).json(table);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update table
export const updateTable = async (req, res) => {
  try {
    const table = await Table.findByPk(req.params.id);
    if (!table) return res.status(404).json({ message: "Table not found" });

    await table.update(req.body);
    res.json({ message: "Table updated", table });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete table
export const deleteTable = async (req, res) => {
  try {
    const table = await Table.findByPk(req.params.id);
    if (!table) return res.status(404).json({ message: "Table not found" });

    await table.destroy();
    res.json({ message: "Table deleted" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
