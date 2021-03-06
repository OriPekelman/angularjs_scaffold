require 'rails/generators'
require 'rails/generators/generated_attribute'

module Angularjs
  class ScaffoldGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :controller_name, :type => :string

    def init_vars
       @model_name = controller_name.singularize #"Post"
       @controller = controller_name #"Posts"
       @resource_name = @model_name.demodulize.underscore #post
       @plural_model_name = @resource_name.pluralize #posts
    end

    def columns
      begin
        excluded_column_names = %w[id _id _type created_at updated_at]
        @model_name.constantize.columns.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type)}
      rescue NoMethodError
        @model_name.constantize.fields.collect{|c| c[1]}.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type.to_s)}
      end
    end

    def generate
      remove_file "app/assets/stylesheets/scaffolds.css.scss"
      append_to_file "app/assets/javascripts/application.js",
        "//= require #{@plural_model_name}_controller"
      append_to_file "app/assets/javascripts/application.js",
        "//= require #{@plural_model_name}"
      insert_into_file "app/assets/javascripts/routes.js.erb",
        ", '#{@plural_model_name}'", :after => "'ngCookies'"
      insert_into_file "app/assets/javascripts/routes.js.erb",
%{    when('/#{@plural_model_name}', {controller:#{@controller}IndexCtrl,
         templateUrl:'<%= asset_path("#{@plural_model_name}/index.html") %>'}).
    when('/#{@plural_model_name}/new', {controller:#{@controller}CreateCtrl,
                templateUrl:'<%= asset_path("#{@plural_model_name}/new.html") %>'}).
    when('/#{@plural_model_name}/:id', {controller:#{@controller}ShowCtrl,
         templateUrl:'<%= asset_path("#{@plural_model_name}/show.html") %>'}).
    when('/#{@plural_model_name}/:id/edit', {controller:#{@controller}EditCtrl,
         templateUrl:'<%= asset_path("#{@plural_model_name}/edit.html") %>'}).\n

}, :before => 'otherwise'
      inject_into_class "app/controllers/#{@plural_model_name}_controller.rb",
        "#{@controller}Controller".constantize, "respond_to :json\n"
      template "new.html",
        "app/assets/templates/#{@plural_model_name}/new.html"
      template "edit.html",
        "app/assets/templates/#{@plural_model_name}/edit.html"
      template "show.html",
        "app/assets/templates/#{@plural_model_name}/show.html"
      template "index.html",
        "app/assets/templates/#{@plural_model_name}/index.html"
      template "plural_model_name.js", "app/assets/javascripts/#{@plural_model_name}.js"
      template "plural_model_name_controller.js",
        "app/assets/javascripts/#{@plural_model_name}_controller.js"
    end
  end
end
