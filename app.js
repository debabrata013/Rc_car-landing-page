const express = require('express');
const path = require('path');
const promClient = require('prom-client');
require('dotenv').config();

console.log('Starting RC Car Landing Page with Prometheus metrics');

// Create a Registry to register the metrics
const register = new promClient.Registry();
// Add default metrics (CPU, memory usage, etc.)
promClient.collectDefaultMetrics({ register });

// Create custom metrics
const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'path', 'status'],
  registers: [register]
});

const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'path', 'status'],
  registers: [register]
});

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Middleware to track request metrics
app.use((req, res, next) => {
  console.log(`Request: ${req.method} ${req.path}`);
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestsTotal.inc({ method: req.method, path: req.path, status: res.statusCode });
    httpRequestDuration.observe({ method: req.method, path: req.path, status: res.statusCode }, duration / 1000);
    console.log(`Response: ${res.statusCode} ${duration}ms`);
  });
  next();
});

// Routes
app.get('/', (req, res) => {
  // Send the HTML file instead of plain text
  res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

// Add metrics endpoint for Prometheus
app.get('/metrics', async (req, res) => {
  console.log('Metrics endpoint called');
  try {
    res.set('Content-Type', register.contentType);
    const metrics = await register.metrics();
    console.log('Metrics generated successfully');
    res.end(metrics);
  } catch (error) {
    console.error('Error generating metrics:', error);
    res.status(500).send('Error generating metrics');
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Metrics available at http://localhost:${PORT}/metrics`);
});
