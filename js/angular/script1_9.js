var oa = angular.module('oa', []);
oa.factory('Data', function(){
  return {message: "Open Assembly"};
});

oa.filter('reverse', function(Data){
  return function(text){
    return text.split("").reverse().join("") + Data.message;
  };
});

oa
  .controller('First', function($scope, Data){
    $scope.data = Data;
  })
  .controller('Second', function($scope, Data){
    $scope.data = Data;
  })
  .controller('Third', function($scope, Data){
    $scope.data = Data;
    $scope.reverseMsg = function(message){
      return message.split("").reverse().join("");
    };
  });

oa.factory('People', function(){
  return [
    {
      name: "Jingen Lin",
      job: "Web Developer"
    },
    {
      name: "Domi En",
      job: "CEO"
    },
    {
      name: "Dustin",
      job: "Senior Developer"
    }
  ];
});

function Search($scope, People){
  $scope.people = People;
}