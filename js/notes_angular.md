ng-controller="Ctrl"
ng-model="name"
ng-model="person.name"
{{name}}
// $watch('modelName', function(){} ------- on.('change', function(){})
var Ctrl = function($scope){ $scope.$watch('name', function(){...} }

ng-show="modelvalue" // check modelValue is trucy or falsy
ng-hide

ng-repeat
script: $scope.names = ["name1", "name2", "name3"]
script: $scope.objects= [obj1, obj2, obj3]

html: li ng-repeat="name in names" {{name}}
html: li ng-repeat="name in names | filter: search(model)" {{name}}
html: li ng-repeat="obj in objects| filter: search" {{obj.attr}}
case sensitive
if item is an object, then use dot (obj.attr)

scope: can assess data from parents, not verse vice (like search above)

<button ng-click="add(); new_name=''; new_age='';">Add</button>
$scope.add = function(){}

array: arr.push(item)

<button ng-click="remove($index)">X</button> // index for li starting at 0
$scope.remove = function(index){}

ng-show="$first"
ng-show="$last"

class="first-{{$first}}" #a way to style it
people.length(array)

ng-change="clean()"

<select ng-model="selectperson" ng-options="person.name for person in people">
    <option value="">Choose a person:</option>
</select>
{{selectperson.name}}

$scope.people = [...]

ng-app="myApp"
var app = angular.module('myApp', [])
app.controller('Ctrl', function($scope){});

app.controller('Example', ['$scope', function(s){}]);

ng-view
<div ng-view></div>
.config(function($routeProvider){}
.when('/contact/:index', {
    templateUrl: 'edit.html',
    controller: 'Edit'
    })
$routeParams.index # in controller

filter:
{{ data | currency:'¢'}} # number:6, upppercase, date:'yyyy-MM-dd'

ng-repeat="name in names | limitTo:3 "  orderBy:
#define a filter
app.filter('clean', function(){
    return function(input, separator){
        return input.toLowerCase;
    }
}
<p>{{text | clean : ' '}}</p>


