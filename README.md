# Product API

A simple Flask REST API to fetch product details from Google Firestore. Designed for deployment on Google Cloud Run using Docker and Cloud Build.

## Features

- Fetch all products from Firestore `/products` collection.
- Each product has `id`, `name`, and `cost` fields.
- Ready for containerization and deployment on Cloud Run.

## Requirements

- Python 3.11
- Google Cloud Project with Firestore enabled
- Service account with Firestore access (if running locally)
- Docker
- gcloud CLI

## Setup

### 1. Install dependencies

```sh
pip install -r requirements.txt
```

### 2. Run locally

Set your Google credentials (if running locally):

```sh
export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/service-account.json"
python product_api.py
```

### 3. Build and deploy with Cloud Build & Cloud Run

#### Build and push Docker image

```sh
gcloud builds submit --config cloudbuild.yaml .
```

#### Deploy to Cloud Run

```sh
gcloud run deploy product-api \
  --image gcr.io/$(gcloud config get-value project)/product-api:latest \
  --platform managed \
  --region YOUR_REGION \
  --allow-unauthenticated
```

Replace `YOUR_REGION` with your preferred GCP region.

## API

### Get all products

```
GET /products
```

**Response:**
```json
[
  {
    "id": "product_id",
    "name": "Product Name",
    "cost": 100
  }
]
```

## License

MIT