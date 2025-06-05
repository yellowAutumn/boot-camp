let config = null;

export async function loadConfig() {
  if (!config) {
    const res = await fetch('/config.json');
    config = await res.json();
  }
  return config;
}