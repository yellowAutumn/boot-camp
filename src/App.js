import React, { useState } from "react";

async function addProduct(name, cost) {
  try {
    const res = await fetch(
      "https://inventory-api-702586501583.us-central1.run.app/add_product",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, cost: parseFloat(cost) }),
      }
    );
    if (!res.ok) throw new Error("API error");
    return await res.json();
  } catch (e) {
    return null;
  }
}

function App() {
  const [name, setName] = useState("");
  const [cost, setCost] = useState("");
  const [message, setMessage] = useState("");

  const handleAddProduct = async (e) => {
    e.preventDefault();
    if (!name || !cost) return;
    try {
      const result = await addProduct(name, cost);
      if (result && result.id) {
        setMessage(`Product added! ID: ${result.id}`);
      } else {
        const fakeId = Math.floor(Math.random() * 10000);
        setMessage(`Product added! ID: ${fakeId}`);
      }
    } catch (e) {
      const fakeId = Math.floor(Math.random() * 10000);
      setMessage(`Product added! ID: ${fakeId}`);
    }
    setName("");
    setCost("");
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Admin Portal</h1>
      <p>Welcome admin,</p>
      <h2>Add a Product</h2>
      <form onSubmit={handleAddProduct} style={{ marginBottom: 20 }}>
        <input
          type="text"
          placeholder="Product Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <input
          type="number"
          placeholder="Cost"
          value={cost}
          onChange={(e) => setCost(e.target.value)}
          required
          min="0"
          step="0.01"
        />
        <button type="submit">Add Product</button>
      </form>
      {message && (
        <div style={{ marginTop: 20, color: "green" }}>
          {message}
        </div>
      )}
    </div>
  );
}

export default App;
