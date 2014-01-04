/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    // Task configuration.
    concat: {
      dist: {
        src: ['clearfix.css', 'specificity.css', 'style.css'],
        dest: 'dist/css/stylesheet.css'
      }
    },
    min:{
      dist:{
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/FILE_NAME.min.js'
      }
    },
    cssmin: {
      compress: {
        files: {
          "dist/css/stylesheet.min.css": ['dist/css/stylesheet.css']
          // "dist/css/stylesheet.min.css": '<config:concat.dist.dest>'
        }
      }
    },
    watch:{
      files: '<initConfig:concat.dist.src>',
      tasks: 'concat cssmin'
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  // grunt.loadNpmTasks('grunt-contrib-mincss');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-watch');
  // Default task.
  grunt.registerTask('default', ['concat', 'cssmin' ]);

};
