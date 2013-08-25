var express = require("express"),
  app = express(),
  redis = require("redis"),
  client = redis.createClient();


app.use(express.bodyParser());

app.get("/props", function(req, res) {
  client.smembers("props", function(error, reply) {
    res.json(reply);
  });
});

app.post("/props", function(req, res) {
  var prop = req.param("prop");
  client.sismember("props", prop, function(error, reply) {
    if (!reply) {
      res.json(501, { message: "No property named " + prop });
    }

    client.hgetall(prop, function(error, reply) {
      res.json(reply);
    });
  });
});

app.use(express.static(__dirname + "/public"));

app.listen(8888);
console.log("Listening on port 8888");

