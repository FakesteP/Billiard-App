const User = require("../models/user");

// Mendapatkan list user
exports.getUsers = async (req, res) => {
  try {
    const users = await User.findAll();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Mengedit user berdasarkan id
exports.editUser = async (req, res) => {
  try {
    const { username, email, point, role } = req.body;
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    if (username !== undefined) user.username = username;
    if (email !== undefined) user.email = email;
    if (point !== undefined) user.point = point;
    if (role !== undefined) user.role = role;
    await user.save();
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Menghapus user berdasarkan id
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    await user.destroy();
    res.json({ message: "User deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
