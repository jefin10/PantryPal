const User = require('../models/User');
const { v4: uuidv4 } = require('uuid');

// Register a new user
exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    
    // Check if user already exists
    const existingUser = await User.findOne({ $or: [{ email }, { username }] });
    if (existingUser) {
      console.log('User already exists:', existingUser);
      return res.status(400).json({ message: 'User already exists with that email or username' });
    }
    
    const user = new User({ username, email, password });
    await user.save();
    
    // Create session
    const sessionId = uuidv4();
    req.session.userId = user._id;
    req.session.sessionId = sessionId;
    
    res.status(201).json({
      message: 'User registered successfully',
      sessionId,
      user: {
        id: user._id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error: error.message });
  }
};

// Login user
exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;
    
    // Find user
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Check password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Create session
    const sessionId = uuidv4();
    req.session.userId = user._id;
    req.session.sessionId = sessionId;
    
    res.json({
      message: 'Login successful',
      sessionId,
      user: {
        id: user._id,
        username: user.username,
        email: user.email
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error: error.message });
  }
};

// Get current user
exports.getCurrentUser = async (req, res) => {
  try {
    const user = await User.findById(req.session.userId).select('-password');
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching user data', error: error.message });
  }
};

// Logout user
exports.logout = async (req, res) => {
  try {
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).json({ message: 'Error logging out' });
      }
      res.clearCookie('connect.sid');
      res.json({ message: 'Logged out successfully' });
    });
  } catch (error) {
    res.status(500).json({ message: 'Error logging out', error: error.message });
  }
};

// Validate session
exports.validateSession = async (req, res) => {
  try {
    // Session is valid if middleware allowed this route to be accessed
    res.json({ 
      valid: true,
      user: {
        id: req.session.userId
      } 
    });
  } catch (error) {
    res.status(500).json({ message: 'Error validating session', error: error.message });
  }
};