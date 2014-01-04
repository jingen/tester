oa = angular.module("oa", []);

oa.directive("enter", function () {
  return function(scope, element, attrs){
    element.bind("mouseenter", function(){
      console.log("I'm inside of you!");
      element.addClass(attrs.enter);
    });
  };
});
oa.directive("leave", function () {
  return {
    restrict: "A",
    link: function(scope, element, attrs){
      element.bind("mouseleave", function(){
        console.log("I'm leaving on a jet plane!");
        element.removeClass(attrs.leave);
      })
    }
  };
});