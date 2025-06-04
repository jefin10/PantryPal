const PantryItem = require('../models/Pantryitem');

// Get all pantry items for a user
exports.getPantryItems = async (req, res) => {
  try {
    const items = await PantryItem.find({ userId: req.session.userId });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pantry items', error: error.message });
  }
};

// Get a single pantry item
exports.getPantryItem = async (req, res) => {
  try {
    const item = await PantryItem.findOne({
      _id: req.params.id,
      userId: req.session.userId
    });
    
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching pantry item', error: error.message });
  }
};

// Create a new pantry item
exports.createPantryItem = async (req, res) => {
  try {
    const { name, quantity, unit, expiryDate, imageUrl } = req.body;
    
    const item = new PantryItem({
      userId: req.session.userId,
      name,
      quantity,
      unit,
      expiryDate,
      imageUrl
    });
    
    await item.save();
    res.status(201).json(item);
  } catch (error) {
    res.status(400).json({ message: 'Error creating pantry item', error: error.message });
  }
};

// Update a pantry item
exports.updatePantryItem = async (req, res) => {
  try {
    const { name, quantity, unit, expiryDate, status, imageUrl } = req.body;
    
    const item = await PantryItem.findOne({
      _id: req.params.id,
      userId: req.session.userId
    });
    
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    if (name) item.name = name;
    if (quantity) item.quantity = quantity;
    if (unit) item.unit = unit;
    if (expiryDate) item.expiryDate = expiryDate;
    if (status) item.status = status;
    if (imageUrl) item.imageUrl = imageUrl;
    
    await item.save();
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: 'Error updating pantry item', error: error.message });
  }
};

// Delete a pantry item
exports.deletePantryItem = async (req, res) => {
  try {
    const item = await PantryItem.findOneAndDelete({
      _id: req.params.id,
      userId: req.session.userId
    });
    
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    res.json({ message: 'Item successfully deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting pantry item', error: error.message });
  }
};

// Get soon-to-expire pantry items
exports.getSoonToExpireItems = async (req, res) => {
  try {
    const daysThreshold = parseInt(req.query.days) || 7;
    const thresholdDate = new Date();
    thresholdDate.setDate(thresholdDate.getDate() + daysThreshold);
    
    const items = await PantryItem.find({
      userId: req.session.userId,
      status: 'active',
      expiryDate: { $lte: thresholdDate, $gte: new Date() }
    }).sort({ expiryDate: 1 });
    
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching soon-to-expire items', error: error.message });
  }
};

// Get expired pantry items
exports.getExpiredItems = async (req, res) => {
  try {
    const today = new Date();
    
    const items = await PantryItem.find({
      userId: req.session.userId,
      expiryDate: { $lt: today },
      status: 'active'
    }).sort({ expiryDate: 1 });
    
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching expired items', error: error.message });
  }
};

// Mark item as consumed
exports.markItemConsumed = async (req, res) => {
  try {
    const item = await PantryItem.findOne({
      _id: req.params.id,
      userId: req.session.userId
    });
    
    if (!item) {
      return res.status(404).json({ message: 'Item not found' });
    }
    
    item.status = 'consumed';
    await item.save();
    
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: 'Error updating item status', error: error.message });
  }
};