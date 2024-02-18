from flask import Flask, request, jsonify
from pymongo import MongoClient
import json  # Import the json module

app = Flask(__name__)

# MongoDB connection
# Replace 'mongodb://localhost:27017/' with your MongoDB connection string
client = MongoClient('mongodb+srv://tubbyaylen:TQLwPR5wxcK7ALaB@trashcans.sgzrgxu.mongodb.net/')
db = client['trashCans']  # Replace 'your_database_name' with your actual database name
collection = db['cans']  # Collection to store trash bins

# Model class
class TrashBin:
    def __init__(self, name, latitude, longitude):
        self.name = name
        self.latitude = latitude
        self.longitude = longitude

# Load data from JSON file and insert into MongoDB
# Replace 'your_json_file.json' with the path to your JSON file containing trash bin data
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

# Routes
@app.route('/add_bin', methods=['POST'])
def add_bin():
    data = request.json
    if data:
        try:
            bin_name = data['name']
            latitude = float(data['latitude'])
            longitude = float(data['longitude'])

            # Create TrashBin object
            new_bin = TrashBin(name=bin_name, latitude=latitude, longitude=longitude)

            # Insert into MongoDB
            result = collection.insert_one({
                'name': new_bin.name,
                'latitude': new_bin.latitude,
                'longitude': new_bin.longitude
            })

            if result.inserted_id:
                return jsonify({'message': 'Bin added successfully', 'bin_id': str(result.inserted_id)}), 200
            else:
                return jsonify({'error': 'Failed to add bin'}), 500
        except KeyError:
            return jsonify({'error': 'Invalid request data. Required fields: name, latitude, longitude'}), 400
        except ValueError:
            return jsonify({'error': 'Latitude and longitude must be float values'}), 400
    else:
        return jsonify({'error': 'No data provided in the request'}), 400

if __name__ == '__main__':
    load_data_from_json('../assets/poi_data.json')  # Call the function to load data from JSON file
    app.run(debug=True)
