
/**
 * Module dependencies.
 */

var express = require('express'),
    routes = require('./routes');

var app = module.exports = express.createServer();

// Configuration

/* Compress generated less files
 * Thanks to Matt Sain - http://stackoverflow.com/a/8379561/713518 */
var less;
express.compiler.compilers.less.compile = function (str, fn) {
  if (!less) {
    less = require("less"); }
    
  try {
    less.render(str, { compress : true }, fn); }
  catch (err) {
    fn(err); }
};

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'your secret here' }));
  app.use(app.router);
  app.use(express.compiler({ src: __dirname + '/public', enable: ['less']}));
  app.use(express['static'](__dirname + '/public'));
  app.use(express.bodyParser());
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);