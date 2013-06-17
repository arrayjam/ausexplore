#!/usr/bin/env node

var fs = require("fs"),
    path = require("path"),
    dsv = require("dsv"),
    optimist = require("optimist"),
    queue = require("queue-async");

var argv = optimist
  .usage("Usage: \033[1mnrp\033[0m [options] [files ...]\n\n")

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
  .check(function(argv) {
    if (!argv._.length) throw new Error("input required");
  })
  .argv;

if (argv.help) return optimist.showHelp();

var entries = [];

console.log(argv);

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

      entries = dsv.parse(text).filter(function(row) {
        return +row["At 30 June - Labels"] === argv.year;
      });

      callback(null);
    });
  };
}

function output(error) {
  if (error) return console.trace(error);

  var out = dsv.csv.format(entries);

  if (argv.o === "/dev/stdout") console.log(out);
  else fs.writeFileSync(argv.o, out, "utf8");
}

function qualify(file) {
  return {
    name: path.basename(file, path.extname(file)),
    path: file
  };
}

