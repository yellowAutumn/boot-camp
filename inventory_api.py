import uuid
from flask import Flask, request, jsonify
from google.cloud import firestore
from google.cloud import pubsub_v1
import json
from datetime import datetime
import logging
import os

app = Flask(__name__)
db = firestore.Client()
publisher = pubsub_v1.PublisherClient()

topic_path = os.environ.get("PUBSUB_TOPIC", "projects/pr-db-fn-1/topics/product-events")


@app.route('/add_product', methods=['POST'])
def add_product():
    data = request.get_json()
    name = data.get('name')
    cost = data.get('cost')
    if not name or not cost:
        return jsonify({'error': 'Missing name or cost'}), 400
    product_id = str(uuid.uuid4())
    product_data = {
        'id': product_id,
        'name': name,
        'cost': cost
    }
    db.collection('product').document(product_id).set(product_data)
    # Publish product info to Pub/Sub topic
   # publisher.publish(topic_path, json.dumps(product_data).encode('utf-8'))
    logging.info(f"Published product: {product_data}")
    # Publish event to Pub/Sub for product creation
    event = {
        "event_id": str(uuid.uuid4()),
        "event_type": "inventory-api",
        "user_id": None,  # or set to the user if available
        "event_timestamp": datetime.utcnow().isoformat() + "Z",
        "event_data": json.dumps({"product_id": product_id, "name": name, "cost": cost})
    }
    publisher.publish(topic_path, json.dumps(event).encode("utf-8"))
    logging.info(f"Published event: {event}")
    return jsonify({'message': 'Product added', 'id': product_id}), 201

if __name__ == '__main__':
    app.run(debug=True)