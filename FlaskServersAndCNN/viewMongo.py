from pymongo import MongoClient

# Connect to MongoDB server
client = MongoClient('mongodb+srv://theogriffinjones:%3Cpo0rtBJe4c7eromw%3E@trashai.ksdqmv9.mongodb.net/')

# Select database
db = client['trashAI']  # Replace with your actual database name

# Select collection
collection = db['trashAI']  # Replace with your actual collection name

# Find all documents in the collection
cursor = collection.find()

# Iterate over the documents and print them
for document in cursor:
    print(document)

# Close connection
client.close()
