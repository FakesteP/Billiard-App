import jwt from "jsonwebtoken";

const authMiddleware = (roles = []) => {
  // roles bisa array, misal ['admin', 'customer'] atau satu role ['admin']
  if (typeof roles === "string") {
    roles = [roles];
  }

  return (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Unauthorized: Token missing" });
    }

    const token = authHeader.split(" ")[1];
    try {
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
      req.user = decoded;

      // Jika roles diberikan, cek apakah user punya role itu
      if (roles.length && !roles.includes(decoded.role)) {
        return res.status(403).json({ message: "Forbidden: Access denied" });
      }

      next();
    } catch (error) {
      return res.status(401).json({ message: "Unauthorized: Invalid token" });
    }
  };
};

export default authMiddleware;
