var gulp = require('gulp');
var browserify = require('gulp-browserify');
var mocha = require('gulp-mocha');
var watch = require('gulp-watch');
var rename = require('gulp-rename');
var clean = require('gulp-clean');
var coffeelint = require('gulp-coffeelint');
var mkdirp = require('mkdirp');

// for mocha
require('coffee-script/register');

var paths = {
  scripts: ['src/**/*.coffee'],
  testCoffee: ['./test/phantom/index.coffee']
};

var outputFile = 'biojs_vis_easy_features.min.js';

var browserifyOptions =  {
  transform: ['coffeeify'],
  extensions: ['.coffee']
};


gulp.task('default', ['lint','build-browser', 'codo']);

gulp.task('clean', function() {
  gulp.src('./build/').pipe(clean());
  mkdirp('./build', function (err) {
    if (err) console.error(err)
});
});

gulp.task('build-browser',['clean'], function() {
  // browserify
  return gulp.src("browser.js")
  .pipe(browserify(browserifyOptions))
  .pipe(rename(outputFile))
  .pipe(gulp.dest('build'));
});


gulp.task('test', function () {
    return gulp.src('./test/mocha/**/*.coffee', {read: false})
        .pipe(mocha({reporter: 'spec',
                    ui: "qunit",
                    compilers: "coffee:coffee-script/register"}));
});


gulp.task('lint', function () {
    gulp.src('./src/**/*.coffee')
        .pipe(coffeelint("coffeelint.json"))
        .pipe(coffeelint.reporter());
});

gulp.task('watch', function() {
   // watch coffee files
   gulp.watch(['./src/**/*.coffee', './test/**/*.coffee'], function() {
     gulp.run('test');
   });
});
