var http = require("http"),
  qs = require("querystring"),
  redis = require("redis"),
  client = redis.createClient();

http.createServer(function(request, response) {
  if (request.method !== "POST") return;

  var body = "";
  request.on("data", function(data) {
    body += data;
  });
  request.on("end", function() {
    var post = qs.parse(body);
    console.log(post);
    console.log(post.prop);
    client.sismember("props", post.prop, function(error, reply) {
      if (reply) {
        console.log("We have a " + post.prop);
      } else {
        console.log("What's a " + post.prop + "?");
      }
    });
  });
  response.end();
}).listen(8888);
