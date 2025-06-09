const express = require("express");
const router = express.Router();
const userController = require("../userController");

// List user
router.get("/users", userController.getUsers);

// Edit user
router.put("/users/:id", userController.editUser);

// Delete user
router.delete("/users/:id", userController.deleteUser);

module.exports = router;
