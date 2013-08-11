var http = require("http"),
  qs = require("querystring"),
  redis = require("redis"),
  client = redis.createClient();

http.createServer(function(request, response) {
  var jsonType = { "Content-Type": "application/json" };
  if (request.method !== "POST") {
    response.writeHead(501, jsonType);
    response.end(JSON.stringify({ message: "POST requests only" }));
  }

  var body = "";
  request.on("data", function(data) {
    body += data;
  });
  request.on("end", function() {
    var post = qs.parse(body);
    client.sismember("props", post.prop, function(error, reply) {
      if (!reply) {
        response.writeHead(501, jsonType);
        response.end(JSON.stringify({ message: "No property named " + post.prop }));
      }

      client.hgetall(post.prop, function(error, reply) {
        response.writeHead(200, { "Content-Type": "application/json" });
        response.end(JSON.stringify(reply));
      });
    });
  });
}).listen(8888);

