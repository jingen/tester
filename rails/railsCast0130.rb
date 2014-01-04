class TasksController < ApplicationController
  def current_user # caching
    @current_user ||= User.find(session[:user])
  end

  def incomplete
    @tasks = Task.find(:all, :conditions => ['complete = ?', false])
    @tasks = Task.find_all_by_complete(false)
  end

  def last_incomplete
    @task = Task.find(:first, :conditions => ['complete = ?', false], :order => 'created_at DESC')
    @task = Task.find_by_complete(false, :order => 'created_at DESC')
  end

  def show
    @project = Project.find(params[:id])
    @tasks = Task.find(:all, :conditions => ['project_id = ? AND complete = ?', @project.id, false])
    @tasks = @project.tasks.find(:all, :conditions => ['complete = ?', false])
    @tasks = @project.tasks.find_all_by_complete(false) # on the associations
  end

  def index
    @tasks = Task.find_incomplete :limite => 20
  end
end

class Task < ActiveRecord::Base
  belongs_to :project
  def self.find_incomplete(options = {}) #class method with "self." , without "self" is an instance method
    with_scope :find => options do
      find_all_by_complete(false, :order => 'created_at DESC')
    end
  end
end

class ProjectController
  has_many :issues
  def show
    @project = Project.find(params[:id])
    @tasks = @Project.tasks.find_incomplete :limite => 20
  end
end

# get all name of project
class project < ActiveRecord:Base
  has_many :tasks

  def self.all_names
    find(:all).collect(&:name)
    # find(:all).collect { |p| p.name }
  end
end

projects.collect(&:name).collect(&:downcase)
projects.all?(&:valid?)
projects.any?(&:valid?)
projects.each(&:save!)

# Layout:
views/
  layouts/
    application.html.erb # for all controllers
    projects.html.erb # for only projects_controller (It has higher priority than application.html.erb)
## specify an layout for a controller
class ProjectController < ApplicationController
  #layout "admin"
  layout :user_layout

  def show
    render :layout => "admin" # indicate the specific layout for a method
    # render :layout => false
  end

  protected
  def user_layout
    if current_user.admin?
      "words"
    else
      "application"
    end
  end  
end

# in the template, 
=begin
<% content_for :head do %>
  <%= stylesheet_link_tag 'project' %>
<% end %>
=end

# in the layout( default: application )
=begin
  <%= content_for?(:head) ? yield(:head) : "" %>
=end

# filtering sensitive logs
class ApplicationController < ActionController
  filter_parameter_logging "password"
end

# refactoring
# def full_name # in user class
# end

=begin
<a href="<%= user_path(user) %>">
  <%= user.full_name %>
</a>
=end
<%= link_to user.full_name, user_path(user) %>

# autotest
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  def test_full_name
    assert_equal 'John Doe', user.full_name('John', nil, 'Doe'), "nil middle initial"
    assert_equal 'John H. Doe', user.full_name('John', 'H', 'Doe'), "H middle initial"
    assert_equal 'John Doe', user.full_name('John', '', 'Doe'), "blank middle initial"
  end

  def full_name(first, middle, last)
    User.new(:first_name => first, :middle_initial => middle, :last_name => last).full_name
  end
end

class User < ActiveRecord::Base
def full_name
  [first_name, middle_initial_with_period, last_name].compact.join(' ')
end

def middle_initial_with_period
  "#{middle_initial}." unless middle_initial.blank? # nil? and "" (empty string)
end

class UserController < ApplicationController
  def prepare
    session[:user_id] = User.find(:first).id
    redirect_to :action => 'show'
  end
  def show
    @user = User.find(session[:user_id])
  end
  def update
    @user = User.find(session[:user_id])
    @user.name = ''
    @user.valid?
    redirect_to :action => 'show'
  end
end

# calculations on models
Task.sum(:priority)
Task.sum(:priority, :conditions => 'complet=0')
Task.maximum(:priority)
Task.average(:priority)
p = Project.find(:first)
p.tasks.sum(:priority) # 9
p.tasks.sum(:priority, :conditions => 'complete=0')

# conditions
Task.count(:all, :conditions => ["complete=? and priority=?", false, 3])
Task.count(:all, :conditions => ["complete=? and priority is ?", false, nil])
# 3.2
Task.all(:conditions => ...).count
# or
Task.where("complete=? and priority=?", false, 3).count
Task.where("complete=? and priority=?", false, 3).entries
Task.where("complete=? and priority in (?)", false, 1...3).count
Task.where("complete=? and priority in (?)", false, 1..3).count
Task.where({:complete => false, :priority => 1}).count
Task.where(:project_id => 1)
Task.find_by_project_id(1) #only get the first matching record
Task.where({:complete => false, :priority => nil}).count
Task.where({:complete => false, :priority => [1,3]}).count
Task.where({:complete => false, :priority => 1...3}).count

#virtual attributes
# attr_accessible :name, :price_in_dollars, :released_at_text, :category_id

def price_in_dollars # get the value
  price_in_cents.to_d/100 if price_in_cents
end

def price_in_dollars=(dollars) #set the value
  self.price_in_cents = dollars.to_d*100 if dollars.present? #self calls the method instead of the variable
end

validate :check_released_at_text
before_save :save_released_at_text

def released_at_text
  @released_at_text || released_at.try(:strftime, "%Y-%m-%d %H:%M:%S")
end

# validates_presence_of :released_at
def save_released_at_text
  self.released_at = Time.zone.parse(@released_at_text) if @released_at_text.present?
rescue ArgumentError
  self.released_at = nil
end
#time convertion: chronic

def check_released_at_text
  if @released_at_text.present? && Time.zone.parse(@released_at_text).nil?
    errors.add :released_at_text, "cannot be parsed"
  end
rescue ArgumentError
  errors.add :released_at_text, "is out of range"
end

before_save :save_tag_names
def tag_names
  @tag_names || tags.pluck(:name).join(" ")
end
def save_tag_names
  if @tag_names
    self.tags = @tag_names.split.map { |name| Tag.where(name: name).first_or_create!}
  end
end

has_many :categories, through: :categorizations # join model
# Join model categorizations
class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :product
end

<%= hidden_field_tag "product[category_ids][]", nil %> #failback
<% Category.all.each do |category| %>
  <%= check_box_tag "product[category_ids][]", category.id, @product.category_ids.include?(category.id), id: dom_id(category) %>
  <%= labe_tag dom_id(category), category.name %><br>
<% end %>
# gem, simple_form

<% flash.each do |key, msg| %>
  <%= content_tag :div, msg, :id=>key %>
<%end%>

# rails g scaffold episode 'admin/episodes'

class ApplicationController < ActionController::Base
  helper_method :admin? #can be used in views, if no this statement, only available in the controllers
  protected
  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to home_path
      false
    end
  end

  # Acts as Authenticated
  def admin?
    #current_user.admin?
    #request.remote_ip = "127.0.0.1"
    session[:password] == 'foobar'
  end
end

before_filter :authorize, :except => :index

class SessionController < ApplicationController
  def create
    session[:password] = params[:password]
    flash[:notice] = 'Successfully logged in'
    redirect_to home_path
  end

  def destroy
    reset_session
    flash[:notice] = 'Successfully logged in'
    redirect_to login_path
  end
end

# eager loading: preloading associated content
@products = Product.order("name")
<%= product.category.name %>
@products = Product.order("name").includes(:category)

# if order by associated table's columns
@products = Product.order("categories.name").joins(:category).select("products.*, categories.name as category_name")

def category_name
  read_attribute("category_name") || category.name
end

Product.joins(:category, :reviews)
Product.joins(:category, :reviews => :user)
Product.joins("left outer join categories on category_id = categories.id")
# bullet gem 

#counter cache column
pluralize project.tasks.size, 'task'
@projects = Project.includes(:issues).all

@tasks = Task.where("name LIKE '%#{params[:query]}%'") # danger, have to avoid
Issue.where("title like '%love%'")
Issue.where(["title like ?", '%#{params[:query]}%']) # escape 

#mass assignment, in the User, attr_protected :admin
#attr_accessible :name
#application.rb: config.active.record.whitelist_attributes = true

# cross site scripting
+ in the view, use h method 
<%= h(comment.content) %> # ***better***
+ in the controller, use CGI::escapeHTML(...)

# in_groups_of(4, ?), if ? is not provided, nil, if false, nothing, if 0, 0
a = (1..12).to_a
a.in_groups_of(4)
=begin
<%@tasks.in_group_of(4, false) do |row_tasks| %>
  <tr>
    <% for task in row_tasks %>
      <td><%= task.name %></td>
    <% end %>
  </tr>
<% end %>
=end

#title
=begin
in the layout
<title>Shoppery - <%= @page_title %></title>/
in the template
<% @page_title = "New Product" %>
=end
in ApplicationHelper
def title(page_title)
  content_for(:title) {page_title}
end
in the layout
<title>shoppery <%= yield(:title) || "The place to Buy Stuff" %></title>/
in the view
<% title "New Product" %>
<h1><%= yield(:title) %></h1>/

# paperclip + crocdoc thumbnails
def gen_file_thumb 
if self.type == "croc" && !self.croc_status
statuses = Crocodoc::Document.status(self.croc_uuid)
if statuses["status"] == "DONE" && statuses["viewable"]
self.croc_status = true
self.image = StringIO.new(Crocodoc::Download.thumbnail(self.croc_uuid, 300, 200))
self.save
end
end
end

def gen_file_thumb 
 if self.type == "croc"
   file = Rails.root.join('public', 'img', 'thumbs', self.croc_uuid + ".png")
   File.new(file, "wb").write(Crocodoc::Download.thumbnail(self.croc_uuid, 300, 300))
   self.set(:file_thumb => "img/thumbs/"+self.croc_uuid+".png")
end
end
