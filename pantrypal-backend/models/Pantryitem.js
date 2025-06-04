const mongoose = require('mongoose');

const PantryItemSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name: { type: String, required: true, trim: true },
  quantity: { type: Number, default: 1, min: 1 },
  unit: {
    type: String,
    enum: ['pcs', 'kg', 'g', 'ltr', 'ml', 'packs', 'boxes'],
    default: 'pcs',
  },
  expiryDate: { type: Date, required: true },
  status: {
    type: String,
    enum: ['active', 'consumed', 'expired'],
    default: 'active',
  },
  imageUrl: { type: String }, 
  addedAt: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('PantryItem', PantryItemSchema);
