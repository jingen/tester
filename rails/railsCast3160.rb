# 31 Time formating
+ issue.updated_at
 => Mon, 28 Oct 2013 22:05:21 UTC +00:00 
+ issue.updated_at.to_s
 => "2013-10-28 22:05:21 UTC" 
+ issue.updated_at.to_s(:long)
 => "October 28, 2013 22:05" 
+ issue.updated_at.to_s(:short)
 => "28 Oct 22:05" 
+ issue.updated_at.to_s(:db)
 => "2013-10-28 22:05:21"
+ issue.updated_at.strftime("updated at %B %d on %I:%M %p")
+ issue.updated_at.to_s(:updated_time)
in the environment.rb
Time::DATE_FORMATS[:updated_time] = "updated at %B %d on %I:%M %p"
$ ri strftime

# 32
f.datetime_select :due_at

def due_at_string
  due_at.to_s(:db)
end

def due_at_string=(due_at_str)
  self.due_at = Time.parse(due_at_str)
rescue ArgumentError
  @due_at_invalid = true
end
# stringify_time :due_at
def validate
  errors.add(:due_at, "is invalid") if @due_at_invalid
end
#chronic

#33 
rails plugin new stringify_time
vendor/plugins/stringify_time/**

#34 named routes
map.task_archive 'tasks/:year/:month', :controller => 'tasks', :action => 'archive'
task_archive_path(2007, 5)
task_archive_path(:year => 2007, :month => 5)

#35 custom rest actions
7 methods(actions): index, show, new, create, edit, update, delete 
map.resources :tasks, :collection => { :completed => :get }, :member => {:complete => :put}# add action
#A member requires an ID, it acts on a member (preview action). A collection route doesn't because it acts on a collection of objects (search action).

(localhost:3000/tasks;completed)
link_to "Completed Tasks", completed_tasks_path %>
link_to "Mark as complete", complete_tasks_path(task), :method => :put %>

def complete
  @task = Task.find(params[:id])
  @task.update_attribute :completed_at, Time.now # update the database
  flash[:notice] = "marked task as complete"
  redirect_to completed_tasks_path #path generating helper
end

#37 search form
<% form_tag projects_path, :method => 'get' do %>
  <% text_field_tag :search, params[:search] %>
  <% submit_tag "Search", :name => nil %>
<% end %>

#38 multi-button
<%=submit_tag 'Preview', :name => 'preview_button'%>
<% if params[:preview_button] %>
    <div id="preview">
      <h2><%= @project.name %></h2>/
      <%= textilize @project.description %>
    </div>/
<%end%>

#39 field-error
in environment.rb
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  "<span class='field_error'>#{html_tag}</span>"
end

#40 blocks in views
in application_helper.rb
module ApplicationHelper
  def admin_area(&block)
    #concat('<div class="admin">', block.binding)
    #yield
    #concat("</div>", block.binding)
    if admin?
      concat content_tag(:div, capture(&block), :class => 'admin'), block.binding
    end
  end

  def side_section(&block)
    @side_sections ||= []
    @side_sections << capture(@block)
  end
end
in view
<% admin_area do %>
  <%= link_to "Edit Task", edit_task_path(@task) %>
<% end %>

<% side_section do %>
  This is on the side bar.
<% end %>

#41 validation
class User < ActiveRecord::Base
  #validates_presence_of :password, :on => :create
  validates_presence_of :password, :if => :should_validate_password?
  validates_presence_of :country
  validates_presence_of :state, :if => :in_us?
  attr_accessor :updating_password

  def in_us?
    country == "US"
  end

  def should_validate_password?
    updating_password || new_record?
  end
end

#in controller
@user.updating_password = true
@user.save # trigger validating action
@user.save(false) #skip all validations, record directly to the database.

#42 with options

with_options :if => :should_validate_password? do |user|
  user.validates_presence_of :password
  user.validates_confirmation_of :password
  user.validates_format_of :password, :with => /^[^\s]+$/
end

routes.rb
map.with_options :controller => 'sessions' do |sessions|
  sessions.login 'login', :action => 'new'
  sessions.logout 'logout', :action => 'destroy'
end

#43 ajax with rjs (js template for rails)
form tag: onsubmit="new Ajax.Request('/reviews', {asynchronous:true, avalScripts:true, parameters:Form.serialize(this)}); return false;"

respond_to do |format|
  format.html { redirect_to product_path(@review.product_id) }
  format.js
end

create.js
page.insert_html :bottom, :reviews, partial => 'review', :object = @review
page.replace_html :reviews_count, pluralize(@review.product.reviews.size, 'Review')
page[:review_form].reset
page.replace_html :notice, flash[:notice]
flash.discard

#44 debug rjs
debug log
open firebug console, check Post, Get message from server side

#45 rjs tips
page.alert('hello!')
page.toggle :review
page[:review].toggle
page[:review_name].value = "this is cool!"
page << "if ($('review_name').value == 'foo'){"
page.alert("hi foo")
page << "}"
page.select("#reviews strong").each do |element|
  element.visual_effect :highlight
end

#46  catch all route
rails g controller redirect 

#match "post/:id" => "posts#show", via: [:get, :post]
#
#controller :blog do
#  get 'blog/show' => :list
#  get 'blog/delete' => :delete
#  get 'blog/edit/:id' => :edit
#end

#map.connect '*path', :controller => 'redirect', :action => 'index'
match "*path", :controller => "redirect", :action => "index", via: [:get, :post]
match "*path" => "redirect#index", via: [:get, :post]
localhost:3000/scd/bar?foo=bar
render :text => params.inspect
params is the following hash:
{"foo"=>"bar", "controller"=>"redirect", "action"=>"index", "path"=>"scd/bar"}

render :text=>request.original_url #with protocol/domian/port
render :text=>request.fullpath #without protocol/domian/port

def index
  product = Product.where("name like ?", "#{params[:path].first}%").first
  redirect_to product_path(product)
end

#47 many to many
one to many
issue, belongs_to :project
project, has_many :issues
rails g migration add_project_id_to_issue project_id:Integer
rake db:migrate
#####

rails g model category name:string
rails g model product name:string
rails g migration create_categories_products_join
class CreateCategoriesProductsJoin < ActiveRecord::Migration
  def change
    create_table :categories_products_joins, {:id => false} do |t|
      t.integer :category_id
      t.integer :product_id
    end
  end
end
rake db:migrate
# can not have multiple join tables
has_and_belongs_to_many :categories
has_and_belongs_to_many :products

#for flexible, use through model
# 1)store extra information in the join 2) treat the join like its own model
rails g model categorization product_id:integer category_id:integer position:integer created_at:datetime
rake db:migrate
class Categorization < ActiveRecord::Base
  belongs_to :product
  belongs_to :category
end
class Categorization < ActiveRecord::Base
  belongs_to :product
  belongs_to :category
end
class Product < ActiveRecord::Base
  has_many :categorizations
  has_many :categories, :through => :categorizations
end

#48 console tricks
rails c --sandbox # Any modifications you make will be rolled back on exit, only sql db, not for mongodb
app.products_path # helper_method
app.get _ #last output
app.class
app.cookies
app.response.headers
pp _; nil
puts app.response.body
app.assgins(:products).size

helper.class
helper.number_to_currency(123.456)
controller
helper.controller = controller
controller.params = { foo: "bar" }
helper.params
reload!
Image.first.to_param #=> id
Product.count
ActiveRecord::Base.logger.level = 1
.irbrc
require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

ActiveRecord::Base.logger.level = 1 if defined? ActiveRecord::Base
def y(obj)
  puts obj.to_yaml
end
y Product.first
class Object
  def mate(method_name)
    file, line = method(method_name).source_location
    `mate '#{file}' -l #{line}`
  end
end
helper.mate(:number_to_currency)
### gem Hirb
### gem 'hirb', group: :development
Gem::Specification.find_by_name("hirb"), #looking for a gem is available or not
def gem_available?(name)
    Gem::Specification.find_by_name(name)
rescue Gem::LoadError
  false
end

#pry-debundle.rb
if defined? Bundler
  Gem.post_reset_hooks.reject! { |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/custom_require.rb'
end
# Hirb.enable, Product.limit(5)
if defined? Rails
  begin
    require 'hirb'
    Hirb.enable
  rescue LoadError
  end
end

require 'awesome_print'
ap Product.first.attributes
# gemirb

# use local gems
gemfile_local = File.join(File.dirname(__FILE__), 'Gemfile.local')
if File.readable?(gemfile_local)
  puts "Loading #{gemfile_local}..." if $DEBUG
  instance_eval(File.read(gemfile_local))
end
###############

require 'clipboard'
Clipboard.copy 'foobar'
Clipboard.paste

require 'methodfinder'
"abc".find_method("ABC") #swapcase, swapcase!, upcase, upcase!

require 'fancy_irb' or FancyIrb.start
require "wirb"
Wirb.start
gem irbtools
pry.github.com

#49 api
+ http://api.rubyonrails.org/
#50 [patch] The Pragmatic Programmers/ 
#51 paginate

#54 debugger
in the code
  debugger

pp @today_tasks
pp @today_tasks.map(&:due_at) # pluck
help
list # l
step
next # n
 irb  # switch to irb
puts where(due_ta: range).to_sql
(date.to_time_in_current_zone)
range = date.beginning_of_day..date.end_of_day
exit # quit from irb
continue
### pry

#55
each_with_index do |line_item, i|
cycle :odd, :even
<td class="price"><%= free_when_zero(line_item.unit_price)%></td>
<td class="price"><%= free_when_zero(line_item.full_price)%></td>
line_item.rb(model)
class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  def full_price
    unit_price*quantity
  end
end
line_item.unit_price*line_item.quantity
in carts_helper.rb
module CartsHelper
  def free_when_zero(price)
    # 
  end
end
[3,4,8,9].inject(:+) # sum it up. [3,4,5,9].inject(0, :+), reduce

@cart.total_price
in cart.rb
def total_price
  line_items.to_a.sum {|line_item| line_item.full_price}
  line_items.to_a.sum(&:full_price)
end

#partial
<%= render :partial => 'line_item', :collection => @cart.line_items %>

#logger
logger.debug "Article Count: #{@articles.size}"
# logger.debug {"Article Count: #{Article.count}"} #pass in a block to avoid making an impact to the performance.
 
# Rails.logger.debug
# debug, info, warn, error, fatal,
production.rb: 
  config_log_level = :debug # :warn
  config_log_tags = [ :subdomain, :uuid, request.remote_ip(or :remote_ip), lambda {|req| Time.now} ] # prepend info for each log message
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
end
log_formatter.rb
class Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "[#{severity}] #{msg}\n"
  end
end

gem 'quiet_assets', group: :development
gem 'thin', group: :development

#57
<%= f.text_field :new_category_name %>
class Product < ActiveRecord::Base
  belongs_to :category
  attr_assessor :new_category_name
  before_save :create_category_from_name

  def create_category_from_name
    create_category(:name => new_category_name) unless new_category_name.blank?
  end
end

#58 make a generator
#59 optimistic locking
rails g migrations add_lock_version_to_products lock_version:integer
class AddLockVersionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :lock_version, :integer, default: 0, null: false
  end
end

rake db:migrate
<%= f.hidden_field :lcok_version %>
product.rb:
  attr_accessible :name, :price, :released_on, :category_id, :lock_version
#rescue ActiveRecord::StaleObjectError
#  render :conflict
def update_with_conflict_validation(*args)
  update_attributes(*args)
rescue ActiveRecord::StaleObjectError
  self.lock_version = lcok_version_was
  errors.add :base, "This record changed while you were editing."
  changes.except("updated_at").each do |name, values|
    errors.add name, "was #{values.first}"
  end
  false
end
##### locking without creating an extra column
<% f.hidden_field :original_updated_at %>
class Product < ActiveRecord::Base
  belongs_to :category
  attr_accessible :name, :price, :released_on, :category_id, :original_updated_at
  validate :handle_conflict, only: :update

  def original_updated_at
    @original_updated_at || updated_at.to_f
  end
  attr_writer :original_updated_at

  def handle_conflict
    if @conflict || updated_at.to_f > original_updated_at.to_f
      @conflict = true
      @original_updated_at = nil
      errors.add :base, "This record changed while you were editing."
      changes.each do |attribute, values|
        errors.add attribute, "was #{values.first}"
      end
    end
  end
end

#60 testing without fixtures
gem mocha
in test_helper.rb
require 'mocha'

