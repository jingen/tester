oa = angular.module("oa", []);
oa.directive("jingenlin", function(){
  return {
    // restrict: "E",
    // template: "<div>Here I am to save the day</div>"

    restrict: "A",
    link: function(){
      alert("I am Jingen Lin.");
    }

    // restrict: "C",
    // link: function(){
    //   alert("I am Jingen Lin.");
    // }
    
    // restrict: "M",
    // link: function(){
    //   alert("I am Jingen Lin.");
    // }
  }
});