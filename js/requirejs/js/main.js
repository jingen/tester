//bootstrap

// require(['jquery', 'person'], function($, person){

// });




// require(["use!backbone"], function(backbone){
//   console.log(backbone);
// });

require(["modules/movie"], function(Movie){
  var movie = new Movie.Model({
    release: 1996,
    title: 'Contact'
  });

  var movieView = new Movie.View({
    model: movie
  });

  $('body').append(movieView.el);
});


// require(['modules/person'], function(person){
//   console.dir(person);
// });

// require(['jquery'], function($){
//   console.dir($);
// });