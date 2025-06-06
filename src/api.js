import { loadConfig } from "./config";

// Mock data
const mockProducts = [
  { id: 1, name: "Product A", price: 10.99 },
  { id: 2, name: "Product B", price: 19.99 },
  { id: 3, name: "Product C", price: 5.49 },
];

export async function fetchProducts() {
  try {
   // const { PRODUCT_API_URL } = await loadConfig();
    const res = await fetch("https://product-api-702586501583.us-central1.run.app/products");
    if (!res.ok) throw new Error("API error");
    const data = await res.json();
    console.log("Fetched products:", data);
    if (!Array.isArray(data) || data.length === 0) return mockProducts;
    return data;
  } catch (e) {
    console.error("Error fetching products:", e);
    return mockProducts;
  }
}

export async function orderProduct(productId) {
  try {
   // const { ORDER_API_URL } = await loadConfig();
    const res = await fetch("https://order-api-ntppvf6llq-uc.a.run.app/order", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ product_id: productId }),
    });
    if (!res.ok) throw new Error("API error");
    const data = await res.json();
    if (!data || !data.id) return { id: Math.floor(Math.random() * 10000), productId };
    return data;
  } catch (e) {
    console.error("Error ordering product:", e);
    return { id: Math.floor(Math.random() * 10000), productId };
  }
}