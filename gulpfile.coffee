browserify  = require 'browserify'
del         = require 'del'
gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
lint        = require 'gulp-coffeelint'
plumber     = require 'gulp-plumber'
rename      = require 'gulp-rename'
uglify      = require 'gulp-uglify'
gutil       = require 'gulp-util'
watch       = require 'gulp-watch'
Server      = (require 'karma').Server
merge2      = require 'merge2'
source      = require 'vinyl-source-stream'
buffer      = require 'vinyl-buffer'
watchify    = require 'watchify'

gulp.task 'lint', ->
  gulp.src('coffee/**/*.coffee')
    .pipe(lint())
    .pipe(lint.reporter())
  gulp.src('test/**/*.coffee')
    .pipe(lint())
    .pipe(lint.reporter())

gulp.task 'coffee', ['lint'], ->
  gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest 'js')

gulp.task 'coffee_test', ['lint'], ->
  gulp.src('test/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest 'js_test')

gulp.task 'watch', ['coffee'], ->
  gulp.watch 'src/**/*.coffee', ['test', 'browserify']
  gulp.watch 'test/**/*.coffee', ['test']

gulp.task 'browserify', ['coffee'], ->
  config =
    packageCache: {}
    cache: {}
    entries: ['index.js']
    debug: false
  bundler = watchify (browserify config)
  rebundle = ->
    base = bundler.bundle()
      .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    one = base
      .pipe(source 'ibex.min.js')
      .pipe(buffer())
      .pipe(uglify())
    two = base
      .pipe(source 'ibex.js')
      .pipe(buffer())
    merge2(one, two)
      .pipe(gulp.dest './dist')
  bundler.on 'update', rebundle
  rebundle()

gulp.task 'test', ['coffee', 'coffee_test'], (done) ->
  config =
    configFile: __dirname + '/karma.conf.js'
    singleRun: true
  (new Server config, -> done()).start()

gulp.task 'clean', -> del(['dist', 'js'])

gulp.task 'default', ['watch', 'browserify']
