# Generated on 2014-09-11 using generator-angular 0.9.8
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt
  pkg = grunt.file.readJSON('./package.json')

  if grunt.file.isFile('./s3.yml')
    s3Config = grunt.file.readYAML('./s3.yml')
    key_id = s3Config.AWS_ACCESS_KEY_ID
    secret = s3Config.AWS_SECRET_ACCESS_KEY
  else
    key_id = ''
    secret = ''
  
  appConfig =
    app: require("./bower.json").appPath or "app"
    dist: "dist"

  
  grunt.initConfig
    
    yeoman: appConfig
    
    jekyll:
      dev:
        options:
          config: "_config.yml"
          dest: ".tmp/docs"

      dist:
        options:
          config: "_config.yml"
          dest: "<%= yeoman.dist %>/docs"

    # Upload to CDN.
    s3:
      options:
        #Accesses environment variables
        key: key_id
        secret: secret
        access: 'public-read'
      production:
        bucket: "cdn.graphalchemist.com"
        upload:[
            # upload the files without version to  CDN
            src: ".tmp/s3/**"
            dest: "/"
        ]

    'string-replace':
      version:
        files:
          './bower.json': './bower.json'
          '<%= yeoman.dist %>/alchemy.js':'<%= yeoman.dist %>/alchemy.js'
          '<%= yeoman.dist %>/alchemy.min.js':'<%= yeoman.dist %>/alchemy.min.js'
        options:
          replacements: [
            pattern: /#VERSION#/ig
            replacement: pkg.version
          ]

    release:
      options:
        file: 'package.json'
        bump: false
        commit: false
        npm: false

    # shell tasks
    shell:
      commitBuild:
        command: "git add -A && git commit -am 'commit dist files for #{pkg.version}'"
      docs:
        command: 'grunt --gruntfile site/Gruntfile.coffee'
    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      jekyll:
        files: ["<%= yeoman.app %>/docs/{,*/,*/*/}*{.scss,.coffee,.html,.md}"]
        tasks: [
          "jekyll:dev"
          "sass:server"
          "coffee:dist"
        ]

      bower:
        files: ["bower.json"]
        tasks: ["wiredep"]

      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: [
          "newer:coffee:test"
          "karma"
        ]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"
                "<%= yeoman.app %>/docs/styles/scss/{,*/}*.{scss,sass}"
              ]
        
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.coffee"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "<%= yeoman.app %>/{,*/}*.html"
          ".tmp/styles/{,*/}*.css"
          ".tmp/scripts/{,*/}*.js"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    "gh-pages":
      options:
        base: "dist"

      src: ["**"]
    
    # The actual grunt server settings
    connect:
      options:
        port: 9002
        
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
        livereload: 35729

      livereload:
        options:
          open: true
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(appConfig.app)
            ]

      test:
        options:
          port: 9001
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect.static("test")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(appConfig.app)
            ]

      dist:
        options:
          open: true
          base: "<%= yeoman.dist %>"

    
    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all:
        src: ["Gruntfile.js"]

    
    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/{,*/}*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]

      server: ".tmp"

    
    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "{,*/}*.css"
          dest: ".tmp/styles/"
        ]

    
    # Automatically inject Bower components into the app
    wiredep:
      app:
        src: ["<%= yeoman.app %>/index.html"]
        ignorePath: /\.\.\//

      sass:
        src: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        ignorePath: /(\.\.\/){1,2}bower_components\//
    
    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          {  
            expand: true
            cwd: "<%= yeoman.app %>/scripts"
            src: "{,*/}*.coffee"
            dest: ".tmp/scripts"
            ext: ".js"
          }
          {
            expand: true
            cwd: "<%= yeoman.app %>/docs/js/coffee"
            src: "*.coffee"
            dest: ".tmp/docs/scripts/"
            ext: ".js"
          }
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    
    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      app:
        options:
          relativeAssets: false
          assetCacheBuster: false
          raw: "Sass::Script::Number.precision = 10\n"
          sassDir: "<%= yeoman.app %>/styles"
          cssDir: ".tmp/styles"
          generatedImagesDir: ".tmp/images/generated"
          imagesDir: "<%= yeoman.app %>/images"
          javascriptsDir: "<%= yeoman.app %>/scripts"
          fontsDir: "<%= yeoman.app %>/styles/fonts"
          importPath: "./bower_components"
          httpImagesPath: "/images"
          httpGeneratedImagesPath: "/images/generated"
          httpFontsPath: "/styles/fonts"
          # generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      docs:
        options:
          assetCacheBuster: false
          raw: "Sass::Script::Number.precision = 10\n"
          debugInfo: true
          sassDir: "<%= yeoman.app %>/docs/styles/scss"
          cssDir: ".tmp/docs/styles"

      # Old tasks from grunt sass
      # dist:
      #   files: [
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/styles"
      #       src: ["*.scss"]
      #       dest: ".tmp/styles"
      #       ext: ".css"
      #     }
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/docs/styles/scss"
      #       src: ["*.scss"]
      #       dest: ".tmp/docs/styles"
      #       ext: ".css"
      #     }
      #   ]
      # server:
      #   files: [
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/styles"
      #       src: ["*.scss"]
      #       dest: ".tmp/styles"
      #       ext: ".css"
      #     }
      #     {
      #       expand: true
      #       cwd: "<%= config.app %>/docs/styles/scss"
      #       src: ["*.scss"]
      #       dest: ".tmp/docs/styles"
      #       ext: ".css"
      #     }
      #   ]

    
    # Renames files for browser caching purposes
    filerev:
      dist:
        src: [
          "<%= yeoman.dist %>/scripts/{,*/}*.js"
          "<%= yeoman.dist %>/styles/{,*/}*.css"
          "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
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

    
    # Performs rewrites based on filerev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        assetsDirs: [
          "<%= yeoman.dist %>"
          "<%= yeoman.dist %>/images"
        ]

    
    # The following *-min tasks will produce minified files in the dist folder
    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/styles/main.css': [
    #         '.tmp/styles/{,*/}*.css'
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
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/images"
        ]

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
          collapseWhitespace: true
          conservativeCollapse: true
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

    
    # ng-annotate tries to make the code safe for minification automatically
    # by using the Angular long form for dependency injection.
    ngAnnotate:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: [
            "*.js"
            "!oldieshim.js"
          ]
          dest: ".tmp/concat/scripts"
        ]

    
    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]

    
    # Copies remaining files to places other tasks can use
    copy:
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
              "fonts/*"
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
            cwd: "."
            src: "bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*"
            dest: "<%= yeoman.dist %>"
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"

    
    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee:dist"
        "compass"
      ]
      test: [
        "coffee"
        "compass"
      ]
      dist: [
        "coffee"
        "compass:dist"
        "imagemin"
        "svgmin"
      ]

    
    # Test settings
    karma:
      unit:
        configFile: "test/karma.conf.coffee"
        singleRun: true

  grunt.registerTask "serve", "Compile then start a connect web server", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "jekyll:dev"
      "wiredep"
      "concurrent:server"
      "autoprefixer"
      "connect:livereload"
      "watch"
    ]
    return

  grunt.registerTask "server", "DEPRECATED TASK. Use the \"serve\" task instead", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve:" + target]
    return

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"
    "autoprefixer"
    "connect:test"
    "karma"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "wiredep"
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngAnnotate"
    "copy:dist"
    "string-replace:version"
    "cdnify"
    "cssmin"
    "uglify"
    "filerev"
    "usemin"
    "htmlmin"
  ]
  grunt.registerTask "default", [
    "newer:jshint"
    "test"
    "build"
  ]
  return