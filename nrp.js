#!/usr/bin/env node

var fs = require("fs"),
    path = require("path"),
    dsv = require("dsv"),
    optimist = require("optimist"),
    queue = require("queue-async");

var argv = optimist
  .usage("Usage: \033[1mnrp\033[0m [options] [files ...]")

  .options("o", {
    alias: "out",
    describe: "output CSV file name",
    default: "/dev/stdout",
  })
  .options("y", {
    alias: "year",
    describe: "year to filter by",
    default: 2011,
  })
  .options("l", {
    alias: "code_length",
    describe: "how many digits the region code length should be. SA2 is 9.",
    default: 9,
  })
  .check(function(argv) {
    if (!argv._.length) throw new Error("input required");
  })
  .argv;

if (argv.help) return optimist.showHelp();

var entries = {};

var q = queue(1);
argv._.forEach(function(file) {
  q.defer(inputFile(dsv.csv), file);
});

q.await(output);

function inputFile(dsv) {
  return function(file, callback) {
    file = qualify(file);
    fs.readFile(file.path, "utf8", function(error, text) {
      if (error) return callback(error);


      //console.log(text);
      if(text === undefined) return;
      dsv.parse(text).forEach(function(row) {
        if (+row.year === +argv.year && row.region_id.length === argv.code_length) {
          if (entries[row.region_id] === null) entries[row.region_id] = {};

          entries[row.region_id] = merge(row, entries[row.region_id]);
        }
      });

      callback(null);
    });
  };
}

function output(error) {
  if (error) return console.trace(error);

  var out = dsv.csv.format(values(entries));

  if (argv.o === "/dev/stdout") console.log(out);
  else fs.writeFileSync(argv.o, out, "utf8");
}

function qualify(file) {
  return {
    name: path.basename(file, path.extname(file)),
    path: file
  };
}

function merge(o1, o2) {
  var o3 = {};
  for (var attr in o1) { o3[attr] = o1[attr]; }
  for (var attr in o2) { o3[attr] = o2[attr]; }
  return o3;
}

function values(map) {
  var vals = [];
  for (var key in map) vals.push(map[key]);
  return vals;
}
