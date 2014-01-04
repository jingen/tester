# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
app.factory "Entry", ['$resource', ($resource) ->
  $resource("/entries/:id", {id: '@id'}, {update: {method: "PUT" }})
]
# @RaffleCtrl = ($scope, Entry) ->
app.controller 'RaffleCtrl', ['$scope', 'Entry', ($scope, Entry) ->
  $scope.entries = Entry.query()
  # console.dir $scope.entries
  # console.log $scope.entries # => [], due to angular return empty object first, then asynchronously fills in data
  $scope.addEntry = ->
    entry = Entry.save($scope.newEntry)
    $scope.entries.push(entry) 
    $scope.newEntry = {}

  $scope.drawWinner = ->
    pool = []
    angular.forEach $scope.entries, (entry) ->
      pool.push(entry) if !entry.winner
    if pool.length > 0
      entry = pool[Math.floor(Math.random()*pool.length)]
      entry.winner = true
      entry.$update()
      $scope.lastWinner = entry
]