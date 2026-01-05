const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");

const app = express();
app.use(express.json());

// Port configuration (use environment variable or default)
const PORT = process.env.PORT || 4020;
const PRISM_TARGET = process.env.PRISM_TARGET || "http://127.0.0.1:4010";

// In-memory cache for catalyst-ids/me endpoint
// Key: _cid (e.g., "preprod.cardano/1lqpGK...")
// Value: { email, username, status, rbac_reg_status }
const catalystIdCache = new Map();

/**
 * Extract _cid from Authorization header
 * Format: Bearer catid.:<timestamp>@<network>.<chain>/<public_key>.<signature>
 * Example: Bearer catid.:1765968337@preprod.cardano/<public_key>.<signature>
 * Returns: preprod.cardano/<public_key>
 */
function extractCidFromAuth(authHeader) {
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return null;
  }

  try {
    // Remove "Bearer " prefix
    const token = authHeader.slice(7);

    // Split by @ to get the part after timestamp
    const atIndex = token.indexOf("@");
    if (atIndex === -1) return null;

    const afterAt = token.slice(atIndex + 1);

    // Find the last dot (signature separator)
    const lastDotIndex = afterAt.lastIndexOf(".");
    if (lastDotIndex === -1) return null;

    // Everything before the last dot is the _cid
    return afterAt.slice(0, lastDotIndex);
  } catch {
    return null;
  }
}

// OVERRIDE ENDPOINTS for /api/catalyst-ids/me
// Note: Path matches the actual Reviews API path (without /reviews prefix)
// Nginx rewrites /api/reviews/catalyst-ids/me -> /api/catalyst-ids/me

// POST - Register/create catalyst ID, cache the data
app.post("/api/catalyst-ids/me", (req, res) => {
  const { email, catalyst_id_uri } = req.body || {};

  // Basic validation
  if (!email || !catalyst_id_uri || !String(catalyst_id_uri).includes("@")) {
    return res.status(400).json({ error: "Invalid payload" });
  }

  const [username, cid] = String(catalyst_id_uri).split("@");

  // Validate Authorization header
  const auth = req.headers.authorization || "";
  if (!auth.startsWith("Bearer ")) {
    return res
      .status(401)
      .json({ error: "Missing/invalid Authorization header" });
  }

  const responseData = {
    _cid: cid,
    email,
    username,
    status: 1,
    rbac_reg_status: 1,
  };

  // Cache the data for subsequent GET requests
  catalystIdCache.set(cid, responseData);
  console.log(`[Cache] Stored catalyst-id data for: ${cid}`);

  return res.status(200).json(responseData);
});

// GET - Retrieve catalyst ID data from cache
app.get("/api/catalyst-ids/me", (req, res) => {
  const auth = req.headers.authorization || "";
  if (!auth.startsWith("Bearer ")) {
    return res
      .status(401)
      .json({ error: "Missing/invalid Authorization header" });
  }

  // Extract _cid from Authorization header
  const cid = extractCidFromAuth(auth);
  if (!cid) {
    return res
      .status(400)
      .json({ error: "Could not extract catalyst ID from token" });
  }

  // Look up cached data
  const cachedData = catalystIdCache.get(cid);
  if (cachedData) {
    console.log(`[Cache] Hit for catalyst-id: ${cid}`);
    return res.status(200).json(cachedData);
  }

  // No cached data - return a default response with extracted cid
  // This handles cases where GET is called without a prior POST
  console.log(`[Cache] Miss for catalyst-id: ${cid}, returning default`);
  return res.status(200).json({
    _cid: cid,
    email: "mock@example.com",
    username: "mock-user",
    status: 1,
    rbac_reg_status: 1,
  });
});

// EVERYTHING ELSE -> PRISM
app.use(
  createProxyMiddleware({
    target: PRISM_TARGET,
    changeOrigin: true,
    logLevel: "silent",
  })
);

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Reviews mock server running on http://0.0.0.0:${PORT}`);
  console.log(`Proxying unhandled requests to ${PRISM_TARGET}`);
});
