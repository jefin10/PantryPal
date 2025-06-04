const express = require('express');
const router = express.Router();
const pantryController = require('../controllers/pantryController');
const { protect } = require('../middleware/auth');

// Protect all pantry routes
router.use(protect);

// Get all pantry items
router.get('/', pantryController.getPantryItems);

// Get soon-to-expire items
router.get('/soon-to-expire', pantryController.getSoonToExpireItems);

// Get expired items
router.get('/expired', pantryController.getExpiredItems);

// Get a single pantry item
router.get('/:id', pantryController.getPantryItem);

// Create a new pantry item
router.post('/', pantryController.createPantryItem);

// Update a pantry item
router.put('/:id', pantryController.updatePantryItem);

// Delete a pantry item
router.delete('/:id', pantryController.deletePantryItem);

// Mark item as consumed
router.patch('/:id/consume', pantryController.markItemConsumed);

module.exports = router;