const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

// List user
router.get("/", userController.getUsers);

// Edit user
router.put("/:id", userController.editUser);

// Delete user
router.delete("/:id", userController.deleteUser);

module.exports = router;
