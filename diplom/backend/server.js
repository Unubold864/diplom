const express = require('express');
const mongoose = require('mongoose');
const axios = require('axios');

const app = express();
const PORT = 5000;

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/travel-app', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error: ', err));

app.use(express.json());

// Sample route for directions (you'll expand this)
app.get('/directions', async (req, res) => {
  const { origin, destination } = req.query;
  
  // Example Google Maps Directions API request
  try {
    const response = await axios.get(`https://maps.googleapis.com/maps/api/directions/json?origin=${origin}&destination=${destination}&key=YOUR_GOOGLE_API_KEY`);
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching directions' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
