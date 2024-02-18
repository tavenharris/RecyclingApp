from flask import Flask, request, jsonify
from pymongo import MongoClient
import json;
app = Flask(__name__)

# MongoDB connection
# Replace 'mongodb://localhost:27017/' with your MongoDB connection string
client = MongoClient('mongodb+srv://theogriffinjones:<po0rtBJe4c7eromw>@trashai.ksdqmv9.mongodb.net/')
db = client['trashAI']  # Replace 'your_database_name' with your actual database name
collection = db['trashAI']  # Collection to store trash bins
filename = 'assets/poi_data.json'

# Model class
class TrashBin:
    def __init__(self, name, latitude, longitude):
        self.name = name
        self.latitude = latitude
        self.longitude = longitude

# Load data from JSON file and insert into MongoDB
def load_data_from_json(filename):
    with open(filename, 'r') as file:
        data = json.load(file)
        print("Data from JSON file:", data)  # Debugging
        for entry in data:
            print("Entry:", entry)  # Debugging
            if isinstance(entry, dict):
                try:
                    new_bin = TrashBin(name=entry['name'], latitude=entry['latitude'], longitude=entry['longitude'])
                    collection.insert_one({
                        'name': new_bin.name,
                        'latitude': new_bin.latitude,
                        'longitude': new_bin.longitude
                    })
                except KeyError:
                    print("Invalid entry:", entry)  # Debugging
            else:
                print("Invalid entry:", entry)  # Debugging

# Function to add a new trash bin to MongoDB
def add_trash_bin(data):
    try:
        bin_name = data['name']
        latitude = float(data['latitude'])
        longitude = float(data['longitude'])

        # Set other fields to null
        address = data.get('address', None)
        city = data.get('city', None)
        state = data.get('state', None)
        zip_code = data.get('zip', None)

        # Insert into MongoDB
        result = collection.insert_one({
            'name': bin_name,
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'city': city,
            'state': state,
            'zip': zip_code
        })

        if result.inserted_id:
            return {'message': 'Bin added successfully', 'bin_id': str(result.inserted_id)}, 200
        else:
            return {'error': 'Failed to add bin'}, 500
    except KeyError:
        return {'error': 'Invalid request data. Required fields: name, latitude, longitude'}, 400
    except ValueError:
        return {'error': 'Latitude and longitude must be float values'}, 400

# Routes
@app.route('/add_bin', methods=['POST'])
def add_bin():
    data = request.json
    if data:
        response, status_code = add_trash_bin(data)
        return jsonify(response), status_code
    else:
        return jsonify({'error': 'No data provided in the request'}), 400

if __name__ == '__main__':
    load_data_from_json('../assets/poi_data.json')  # Call the function to load data from JSON file
    app.run(debug=True)
