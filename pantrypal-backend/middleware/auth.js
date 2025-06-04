const User = require('../models/User');

const protect = async (req, res, next) => {
  try {
    // Check if session exists and contains userId
    if (!req.session || !req.session.userId) {
      return res.status(401).json({ message: 'Not authorized, no valid session' });
    }

    // Get user from session
    const user = await User.findById(req.session.userId);
    if (!user) {
      return res.status(401).json({ message: 'User not found' });
    }
    
    // All good, proceed
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(401).json({ message: 'Not authorized, session validation failed' });
  }
};

module.exports = { protect };