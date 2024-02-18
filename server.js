const express = require('express');
const { MongoClient } = require('mongodb');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors()); // Enable CORS for all origins (consider tightening this for production)

// MongoDB connection URI
const uri = 'mongodb+srv://theogriffinjones:po0rtBJe4c7eromw@trashai.ksdqmv9.mongodb.net/'
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

// Connect to MongoDB
async function connectToMongoDB() {
    try {
        await client.connect();
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('Could not connect to MongoDB', error);
        process.exit(1);
    }
}

connectToMongoDB();

// Assuming you have a "trashBins" collection in your MongoDB
const db = client.db('trashAI');
const collection = db.collection('trashAI');

// Routes
// Get all trash bin locations
app.get('/trashbins', async (req, res) => {
    try {
        const trashBins = await collection.find({}).toArray();
        res.status(200).json(trashBins);
    } catch (error) {
        res.status(500).json({ message: 'Failed to get trash bins', error });
    }
});

// Add a new trash bin location
app.post('/trashbins', async (req, res) => {
    try {
        const { name, latitude, longitude } = req.body;
        const result = await collection.insertOne({ name, latitude, longitude });
        res.status(201).json({ message: 'Trash bin added', result });
    } catch (error) {
        res.status(500).json({ message: 'Failed to add trash bin', error });
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});
