d3.json("data/sa2_2011.json", function(error, geo) {
  var projection = d3.geo.mercator()
    .center([132.5, -26.5])
    .scale(500);

  var path = d3.geo.path()
    .projection(projection);

  var svg = d3.select("svg");

  svg.selectAll("path")
    .data(topojson.feature(geo, geo.objects.sa2).features)
    .enter().append("path")
    .attr("d", path);
});
