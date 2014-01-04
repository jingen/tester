oa = angular.module("oa", []);

oa.controller("LoadMoreTweets", function($scope){
  $scope.loadMoreTweets = function(){
    alert("load more tweets.");
  };
  $scope.deleteMoreTweets = function(){
    alert("delete the tweets.");
  };
});

oa.directive("enter", function(){
  return function(scope, element, attrs){
    element.bind("mouseenter", function(){
      scope.$apply(attrs.enter);
    });
  };
});