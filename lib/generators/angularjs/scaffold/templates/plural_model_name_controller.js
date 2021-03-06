function <%= @controller%>IndexCtrl($scope, <%= @model_name%>) {
  $scope.<%= @plural_model_name %> = <%= @model_name%>.query();

  $scope.destroy = function() {
    dconfirm = confirm('Are you sure?');
    if(dconfirm){
      var original = this.<%= @resource_name%>
      this.post.destroy(function() {
        $scope.posts = _.without($scope.<%= @plural_model_name%>, original);
      });
    }
  };
}

function <%= @controller%>CreateCtrl($scope, $location, <%= @model_name%>) {
  $scope.save = function() {
    <%= @model_name%>.save($scope.<%= @resource_name%>, function(<%= @resource_name%>) {
      $location.path('/<%= @plural_model_name %>/' + <%= @resource_name%>.id + '/edit');
    });
  }
}

function <%= @controller%>ShowCtrl($scope, $location, $routeParams, <%= @model_name%>) {
  <%= @model_name%>.get({id: $routeParams.id}, function(<%= @resource_name%>) {
    self.original = <%= @resource_name%>;
    $scope.<%= @resource_name%> = new <%= @model_name%>(self.original);
  });  
}

function <%= @controller%>EditCtrl($scope, $location, $routeParams, <%= @model_name%>) {
  var self = this;

  <%= @model_name%>.get({id: $routeParams.id}, function(<%= @resource_name%>) {
    self.original = <%= @resource_name%>;
    $scope.<%= @resource_name%> = new <%= @model_name%>(self.original);
  });

  $scope.isClean = function() {
    return angular.equals(self.original, $scope.<%= @resource_name%>);
  }

  $scope.destroy = function() {
    dconfirm = confirm('Are you sure?');
    if(dconfirm){
      $scope.<%= @resource_name %>.destroy(function() {
      $location.path('/<%= @plural_model_name %>');
    });}
  };

  $scope.save = function() {
    <%= @model_name%>.update($scope.<%= @resource_name%>, function(<%= @resource_name%>) {
      $location.path('/<%= @plural_model_name %>');
    });
  };
}
