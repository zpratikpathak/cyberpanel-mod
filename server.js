const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ status: 1 }));
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`CyberPanel Mod server running on http://0.0.0.0:${PORT}`);
});
