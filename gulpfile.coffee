gulp = require 'gulp'
$ = require('gulp-load-plugins')()
paths =
  coffeePath: 'src/js/**/*.coffee'
  lessPath: 'src/css/**/*.less'
  uglifyPath: ['src/js/**/*.js','!src/js/libs/*','!src/js/config.js']
  baseui:
    'css': ['src/bower_components/bootstrap/dist/css/bootstrap.min.css']
    'fonts': ['src/bower_components/bootstrap/dist/fonts/*']
    'images': ['src/images/**/*']
  libs: [
    'src/bower_components/**/*.min.js',
    'src/js/libs/**/*.min.js',
    '!src/bower_components/**/md5.min.js',
    '!src/bower_components/**/sizzle.min.js',
    '!src/bower_components/bootstrap/**/*.js',
  ]
  basejs: [
    'src/js/libs/adapter.js',
    'src/bower_components/js-md5/src/md5.js',
    'src/js/libs/GPS.js',
    'src/bower_components/json2/json2.js'
  ]
  html: ['src/html/**/*.jade', '!src/html/include/*']
  dest: "dist/"
  src: "src/"
gulp.task('layout', ->
  gulp.src(paths.baseui.css)
    .pipe($.plumber())
    .pipe($.rename('base.css'))
    .pipe(gulp.dest("""#{paths.dest}css/layout"""))
)
gulp.task('basejs', ->
  gulp.src(paths.basejs)
    .pipe($.plumber())
    .pipe($.concat('base.js'))
    .pipe($.uglify(
      mangle: false
    ))
    .pipe(gulp.dest("""#{paths.dest}/js/libs"""))
)
gulp.task('template', ->
  gulp.src(paths.html)
    .pipe($.plumber())
    .pipe($.jade
      pretty: true
    )
    .pipe(gulp.dest("""#{paths.dest}html"""))
)
gulp.task('imagesmin', ->
  gulp.src(paths.baseui.images)
    .pipe($.plumber())
    .pipe($.imagemin(
      progressive: true
      interlaced: true
    ))
)
gulp.task('copyfont', ->
  gulp.src(paths.baseui.fonts)
    .pipe($.plumber())
    .pipe($.copy("""#{paths.dest}/css/""", prefix: 4))
)
gulp.task('copyconfig', ->
  gulp.src('src/js/config.js')
    .pipe($.plumber())
    .pipe($.copy("""#{paths.dest}/js/""", prefix: 2))
)
gulp.task('copyjs', ->
  gulp.src(paths.libs)
    .pipe($.plumber())
    .pipe($.copy("""#{paths.dest}/js/libs""", prefix: 4))
)
gulp.task('copyimages',['imagesmin'], ->
  gulp.src(paths.baseui.images)
    .pipe($.plumber())
    .pipe($.copy("""#{paths.dest}/images""", prefix: 2))
)
gulp.task('less', ->
  gulp.src(paths.lessPath)
    .pipe($.plumber())
    .pipe($.less(
      compress: true
    ))
    .pipe(gulp.dest("""#{paths.dest}css"""))
)
gulp.task('coffee', ->
  gulp.src(paths.coffeePath)
    .pipe($.plumber())
    .pipe($.coffee(
      bare: true
    ))
    .pipe($.uglify({
      mangle: false
      compress: false
    }))
    .pipe(gulp.dest("""#{paths.dest}js"""))
)
gulp.task('uglifyjs', ->
  gulp.src(paths.uglifyPath)
    .pipe($.plumber())
    .pipe($.uglify({
      mangle: false
      compress: false
    }))
    .pipe(gulp.dest("#{paths.dest}/js"))
)

###文件复制###
gulp.task('copy', ['copyjs', 'copyconfig', 'copyfont', 'copyimages'])
###类库编译###
gulp.task('core', ['basejs', 'layout', 'copy'])
###各业务编译###
gulp.task('business', ['coffee', 'less', 'template'])
###实时监控###
gulp.task('watch', ->
  gulp.watch(paths.coffeePath, ['coffee'])
  gulp.watch(paths.lessPath, ['less'])
  gulp.watch(paths.html, ['template'])
  #gulp.watch(paths.uglifyPath, ['uglifyjs'])
)
###清空项目###
gulp.task('clean', ->
  gulp.src(paths.dest, {force: true})
    .pipe($.clean())
)
###项目构建###
gulp.task('bulid', ['core', 'business'])
###默认执行任务###
gulp.task('default', ['bulid'])
###构建类库支持CMD模块###
gulp.task('uglify', ->
  gulp.src([
    'src/bower_components/jquery/dist/jquery.js',
    'src/bower_components/underscore/underscore.js',
    'src/bower_components/underscore/underscore.js']
  )
    .pipe($.uglify())
    .pipe(gulp.dest('src/bower_components/uglify'))
)
