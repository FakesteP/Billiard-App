// Dummy data user
let users = [
  { id: 1, name: "User Satu", email: "user1@email.com" },
  { id: 2, name: "User Dua", email: "user2@email.com" },
];

// Mendapatkan list user
exports.getUsers = (req, res) => {
  res.json(users);
};

// Mengedit user berdasarkan id
exports.editUser = (req, res) => {
  const id = parseInt(req.params.id);
  const { name, email } = req.body;
  const user = users.find((u) => u.id === id);
  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }
  if (name) user.name = name;
  if (email) user.email = email;
  res.json(user);
};

// Menghapus user berdasarkan id
exports.deleteUser = (req, res) => {
  const id = parseInt(req.params.id);
  const index = users.findIndex((u) => u.id === id);
  if (index === -1) {
    return res.status(404).json({ message: "User not found" });
  }
  users.splice(index, 1);
  res.json({ message: "User deleted" });
};
