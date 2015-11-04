# Generated on 2014-04-22 using generator-angular 0.8.0
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
modRewrite = require('connect-modrewrite')
mountFolder = (connect, dir) ->
  console.log dir
  connect.static(require('path').resolve(dir))


module.exports = (grunt) ->

  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt

  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt

  # Define the configuration for all the tasks
  grunt.initConfig

  # Project settings
    yeoman:

    # configurable paths
      app: require("./bower.json").appPath or "app"
      dist: "dist"


  # Watches files for changes and runs tasks based on the changed files
    watch:
      bower:
        files: ["bower.json"]
        tasks: ["bowerInstall"]

      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: [
          "newer:coffee:test"
          "karma"
        ]

      less:
        files: ["<%= yeoman.app %>/styles/{,*/}*.less"]
        tasks: ["less"]
        options:
          nospawn: true

      gruntfile:
        files: ["Gruntfile.js"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          ".tmp/scripts/{,*/}*.js"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    proxy:
      api:
        options :
          port : 9001
          host : 'localhost'
          target :
            host: 'app.switchfit.io.dev.wuestkamp.com'
            port: 80

  # The actual grunt server settings
    connect:
      options:
        port: 8888

      # Change this to '0.0.0.0' to access the server from outside.
        hostname: "0.0.0.0"
        livereload: 35729
      server: {
        proxies: [
          {
            context: [ '/api', '/login', '/login_check', '/logout', '/assets', '/bundles', '/media', '/resetting' ],
            host: 'app.switchfit.io.dev.wuestkamp.com',
            port: 80,
            https: false,
            changeOrigin: false,
            xforward: false,
            headers:
              host: "app.switchfit.io.dev.wuestkamp.com"
          }
        ]
      }
      server2: {
        proxies: [
          {
            context: [ '/api', '/login', '/login_check', '/logout', '/assets', '/bundles', '/media', '/resetting' ],
            host: 'app.switchfit.lo',
            port: 8080,
            https: false,
            changeOrigin: false
            xforward: false,
            headers:
              host: "app.switchfit.lo"
            rewrite: {
              '^/api': '/app_dev.php/api',
              '^/login': '/app_dev.php/login',
              '^/login_check': '/app_dev.php/login_check',
              '^/logout': '/app_dev.php/logout',
              '^/resetting': '/app_dev.php/resetting',
              '^/promo': '/app_dev.php/promo',
            }
          }
        ]
      }

      livereload:
        options:
          middleware: (connect) ->
            [
              require('grunt-connect-proxy/lib/utils').proxyRequest
              modRewrite(['!\\.html|\\.js|\\.svg|\\.css|\\.png|\\.jpg|\\.otf|\\.eot|\\.svg|\\.ttf|\\.woff$ /index.html [L]'])
              mountFolder(connect, '.tmp')
              mountFolder(connect, "app")
            ]
          open: false

      test:
        options:
          port: 9001
          base: [
            ".tmp"
            "test"
            "<%= yeoman.app %>"
          ]

      dist:
        options:
          base: "<%= yeoman.dist %>"

    browserSync:
      dev:
        bsFiles:
          src: [
            ".tmp/styles/*.css"
            "<%= yeoman.app %>/{,*/}*.html"
          ]

        options:
          watchTask: true
          host : "localhost"


  # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: ["Gruntfile.js"]


  # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]

      server: ".tmp"


  # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: [
          "last 2 versions"
          "ie 9"
          "opera 12"
        ]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "{,*/}*.css"
          dest: ".tmp/styles/"
        ]


  # Automatically inject Bower components into the app
    bowerInstall:
      app:
        src: ["<%= yeoman.app %>/index.html"]
        ignorePath: "<%= yeoman.app %>/"


  # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]


  # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/{,*/}*.js"
            "<%= yeoman.dist %>/styles/{,*/}*.css"
            #"<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= yeoman.dist %>/styles/fonts/*"
          ]


  # Reads HTML for usemin blocks to enable smart builds that automatically
  # concat, minify and revision files. Creates configurations in memory so
  # additional tasks can operate on them
    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"
        flow:
          html:
            steps:
              js: [
                "concat"
                "uglifyjs"
              ]
              css: ["cssmin"]

            post: {}


  # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        assetsDirs: ["<%= yeoman.dist %>"]

    less:
      development:
        options:
          compress: false
          yuicompress: false
          optimization: 2
          strictMath: true
          sourceMap: true
          outputSourceFiles: true
          sourceMapBasepath: ".tmp/styles/"
          sourceMapFilename: ".tmp/styles/all.css.map"

        files:
          ".tmp/styles/all.css": "<%= yeoman.app %>/styles/all.less"


  # production: {
  #        options: {
  #          strictMath: true,
  #          sourceMap: true,
  #          outputSourceFiles: true,
  #          sourceMapBasepath: '<%= yeoman.dist %>/styles/',
  #          sourceMapFilename: '<%= yeoman.dist %>/styles/all.css.map'
  #        },
  #        files: {
  #          '<%= yeoman.dist %>/styles/all.css': '<%= yeoman.app %>/styles/all.less'
  #        }
  #      },
  #      minify: {
  #        options: {
  #          cleancss: true,
  #          report: 'min'
  #        },
  #        files: {
  #          '<%= yeoman.dist %>/styles/all.min.css': '<%= yeoman.dist %>/styles/all.css'
  #        }
  #      }

  # The following *-min tasks produce minified files in the dist folder
    cssmin:
      options: {}
  #root: "<%= yeoman.app %>"

#    imagemin:
#      dist:
#        files: [
#          expand: true
#          cwd: "<%= yeoman.app %>/images"
#          src: "{,*/}*.{png,jpg,jpeg,gif}"
#          dest: "<%= yeoman.dist %>/images"
#        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        options:
          collapseWhitespace: false
          collapseBooleanAttributes: true
          removeCommentsFromCDATA: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: [
            "*.html"
            "views/{,*/}*.html"
          ]
          dest: "<%= yeoman.dist %>"
        ]


  # ngmin tries to make the code safe for minification automatically by
  # using the Angular long form for dependency injection. It doesn't work on
  # things like resolve or inject so those have to be done manually.
    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: "*.js"
          dest: ".tmp/concat/scripts"
        ]


  # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]


  # Copies remaining files to places other tasks can use
    copy:
      dev:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>/bower_components/components-font-awesome/fonts/"
            dest: ".tmp/fonts"
            src: [
              "*.*"
            ]
          }
        ]
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "*.html"
              "views/{,*/}*.html"
              "images/{,*/}*.{webp}"
              "temp-img/{,*/}*.*"
              "styles/fonts/{,*/}*.*"
              "scripts/dependencies/*.*"
            ]
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: ["generated/*"]
          }
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>/bower_components/components-font-awesome/fonts/"
            src: ["*.*"]
            dest: "<%= yeoman.dist %>/fonts"
          }
          {
            expand: true
            cwd: "<%= yeoman.app %>/images"
            src: "{,*/}*.{png,jpg,jpeg,gif}"
            dest: "<%= yeoman.dist %>/images"
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"

      ckeditor:
        files: [
          {
            expand: true
            cwd: ".tmp/styles"
            dest: "<%= yeoman.dist %>/ckeditor"
            src: ["*.css"]
          }
        ]

  # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee:dist"
        "copy:styles"
      ]
      test: [
        "coffee"
        "copy:styles"
      ]
      dist: [
        "coffee"
        "copy:styles"
#        "imagemin"
        "svgmin"
      ]

    targethtml: {
      serve: {
        files: {
          './.tmp/index.html': './app/index.html'
        }
      }
      serve_local: {
        files: {
          './.tmp/index.html': './app/index.html'
        }
      }
      dist: {
        files: {
          'dist/index.html': 'dist/index.html'
        }
      }
    }


  # By default, your `index.html`'s <!-- Usemin block --> will take care of
  # minification. These next options are pre-configured if you do not wish
  # to use the Usemin blocks.
  # cssmin: {
  #   dist: {
  #     files: {
  #       '<%= yeoman.dist %>/styles/main.css': [
  #         '.tmp/styles/{,*/}*.css',
  #         '<%= yeoman.app %>/styles/{,*/}*.css'
  #       ]
  #     }
  #   }
  # },
  # uglify: {
  #   dist: {
  #     files: {
  #       '<%= yeoman.dist %>/scripts/scripts.js': [
  #         '<%= yeoman.dist %>/scripts/scripts.js'
  #       ]
  #     }
  #   }
  # },
  # concat: {
  #   dist: {}
  # },

  # Test settings
    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true

    symlink:
      options: {
        overwrite: true
      }
      explicit: {
        src: ".tmp/styles",
        dest: ".tmp/ckeditor"
      }

  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-browser-sync"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-connect-proxy"
  grunt.loadNpmTasks "grunt-targethtml"
  grunt.loadNpmTasks 'grunt-contrib-symlink'
#  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "copy:dev"
      "targethtml:serve"
      #"bowerInstall"
      "concurrent:server"
      "less"

      #'autoprefixer',
      'configureProxies:server'
      "connect:livereload"
      #"browserSync"
      "watch"
    ]
    return
  grunt.registerTask "serve_local", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "copy:dev"
      "targethtml:serve_local"
      "bowerInstall"
      "concurrent:server"
      "less"
      "symlink"

      #'autoprefixer',
      'configureProxies:server2'
      "connect:livereload"
#      "browserSync"
      "watch"
    ]
    return

  grunt.registerTask "server", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve:" + target]
    return

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"

    # 'autoprefixer',
    "connect:test"
    "karma"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "bowerInstall"
    "useminPrepare"
    "concurrent:dist"
    "less"

    # 'autoprefixer',
    "concat"
    "ngmin"
    "copy:dist"
    "copy:ckeditor"
    "targethtml:dist"
    "cdnify"
    "cssmin"
    "uglify"
    "rev"
    "usemin"
    "htmlmin"
  ]
  grunt.registerTask "default", [
    "newer:jshint"
    "test"
    "build"
  ]
  return