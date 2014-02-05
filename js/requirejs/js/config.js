require.config({
  deps: ['main'],
  paths: {
    'use': 'libs/use',
    'jquery': 'libs/jquery-1.11.0',
    'underscore': 'http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min',
    'backbone': 'http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min'
  },

  use: {
    backbone: {
      deps: ['underscore', 'jquery'],
      attach: 'Backbone'
    }
  }
});