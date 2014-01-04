oa = angular.module("oa", []);

oa.directive("superhero", function () {
  return {
    restrict: "E",
    // scope: {},// isolate it from other directives | separate scopes for different directives
    controller: function($scope){
      $scope.abilities = [];

      this.addStrength = function(){
        $scope.abilities.push("strength");
      };
      this.addSpeed = function(){
        $scope.abilities.push("speed");
      };
      this.addFlight = function(){
        $scope.abilities.push("flight");
      };
    },
    link: function(scope, element){
      element.addClass('btn');
      element.bind("mouseenter", function(){
        console.log(scope.abilities);
      });
    }
  }
});
oa.directive("strength", function(){
  return {
    require: "superhero",
    link: function(scope, element, attrs, superCtrl){
      element.bind("click", function(){
        superCtrl.addStrength();
      });
    }
  }
});
oa.directive("speed", function(){
  return {
    require: "superhero",
    link: function(scope, element, attrs, superCtrl){
      element.bind("click", function(){
        superCtrl.addSpeed();
      });
    }
  }
});
oa.directive("flight", function(){
  return {
    require: "superhero",
    link: function(scope, element, attrs, superCtrl){
      element.bind("click", function(){
        superCtrl.addFlight();
      });
    }
  }
});