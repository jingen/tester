#91 refactoring long methods
def total_weight
  @total_weight ||= line_items.to_a.sum(&:weight)
end

in line_item class
method weight to calculate the weight for the line_item

#92 make-resourceful
index, show, new, edit, create, update, destroy
make_resourceful do
  actions :all # :index, :show

  after :update do # or :update_fails
    flash[:notice] = "Successfully updated."
  end

  response_for :show do |format|
    format.html
    format.xml { render :xml => current_object.to_xml }
  end
end

def current_objects # plural objects
  Product.find(:all, :order=>'name')
end

def current_object # singular object
  @current_object ||=  Product.find_by_permalink(params[:id])
end
<%= hidden_field_tag '_flash[notice]', "Successfully updated" %>

>
#actions caching
when before_filter :authorize ... gets triggered
caches_action :index, :cache_path => :index_cache_path.to_proc

def expire_cache(product)
  # expire_action products_path
  expire_action '/admin/products'
  expire_action '/public/products'
end

helper_method :admin?
private
 def admin?
   ...
 end
 def index_cache_path
   if admin?
    '/admin/products'
   else
    '/public/products'
   end
 end

#94 active resources, resource from other sites
class Product < ActiveResource::Base
  self.site = "http://localhost:3000" # product render :xml => @products
  #self.site = "http://admin:secret@localhost:3000" # product render :xml => @products
  #other parameters
  self.prefix = 'foo/bar/'
  self.element_name = "item"
  self.collection_name = "store_items"
end
rails g migration add_product_to_posts product_id:integer
class Post < ActiveResource::Base
  def product
    @product ||= Product.find(product_id) unless product_id.blank?
  end
end
<% if @post.product %>
  <strong><%= h @post.product.name %></strong>
<% end %>
>
Product.find(:all, :params => {:search => 'table'})
/products.xml?search=table
/
p = Product.create(:name => 'foo')
p.save # PUT request 
p.destroy # DELETE request

in routes
resource :products, :collection => { :recent => :get }
                    :member => { :discontinue => :put }
p.get(:recent)
p.put(:discontinue)

#96 git on rails
in .gitignore
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3

touch vendor/.gitignore # because if a directory is empty, git will not add it to the repository

#97 production log
Rails Analyzer
rawk
 : 
class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg} (pid:#{$$})\n"
  end
end

#98 request profiling
config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true

config.log_level = :debug

Optimization (check which should be focused to optimize)
Completed (time) Rendering: (time) DB: (time)

sudo gem install ruby-prof
get "/products"
RAILS_ENV=staging script/performance/request lib/products_index_profiler.rb

request
call_methods

#99 complex partials
<%= render :partial => @article %>
>
<% render :layout => 'article', :object => @article do %>
  ...
<% end %> >

in layout(application.html.erb):
<%= yield(:head) %>
in application_helper.rb:
>
def stylesheet(*args)
  content_for(:head) { stylesheet_link_tag(*args)}
end

#100 5 view tips
"
<%- for ... -%>
<%- end -%>
"
- means not outputing anything

<%= yield(:side) || render(:partial => "...") %>

debug in view 
<%= debug @products %>
# params, request.env

<%= render :partial => @product, :locals => { :show_price => true } %>
>
helper_method: display_product @product, :show_price => true

module ProductsHelper
  def display_product(product, locals={})
    locals.reverse_merge! :show_price => false
    render :partial => product, :locals => locals
  end
end

# 101 refactoring out helper objects
<% for product in @products %>
  <h3><%=h product.name %></h3>
  #<%= render_stars(product.rating) %>
  <%= render_stars(product.rating) %>
<%end%>

in helpers/stars_renderer.rb
class StarsRenderer
  def initialize(rating, template)
    @rating = rating
    @template = template
    # @template.content_tag ... or use method_missing
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
  ......
end

in application_helper
def render_stars(rating)
  StarsRenderer.new(rating, self).render_stars
end

# 102 auto complete association
class Product < ActiveRecord::Base
  belongs_to :category

  def category_name
    category.try(:name)
  end

  def category_name=(name)
    # self.category = Category.find_by_name(name) if name.present?
    self.category = Category.find_or_create_by_name(name) if name.present?
  end
end

jQuery ui for autocomplete

#103 site wide announcement
gems: rspec-rails, capybara, launchy, poltergeist

rails g integration_test announcement
in spec/request/announcement_spec.rb

require 'spec_helper'
describe 'Announcement' do
  it "displays active announcements" do
    Announcement.create! message: "Hello World", starts_at: 1.hour.ago, ends_at: 1.hour.from_now
    Announcement.create! message: "Upcoming", starts_at: 10.minutes.from_now, ends_at: 1.hour.from_now
    visit root_path
    page.should have_content("Hello World") # msg shows up
    page.should_not have_content("Upcoming")
    click_on "hide announcement"
    page.should_not have_content("Hello World")
  end
end

rake spec

rails g model announcement message:text starts_at:datetime ends_at:datetime
scope :current, -> { where("starts_at <= :now and ends_at >= :now", now: Time.zone.now)}

#104 Exception Notifications
gem 'exception_notification'

config.middleware.use ExceptionNotifier,
  sender_address: 'noreply@railscasts.com',
  exception_recipients: 'ryan@railscasts.com'
  ignore_exceptions: ExceptionNotifier.default_ignore_exceptions # + [RuntimeError]

gem "Whoops"
gem "Airbrake"
277 Mountable Engines

#105
#106 time zones
rake time:zones:all
in environment.rb
initializer.run do
  ...
  config.time_zone = "Pacific Time (US & Canada)"
end

Product.first.released_at_before_type_cast

User model
:time_zone 

TimeZone.us_zones

in ApplicationController < ActionController::Base
before_filter :set_user_time_zone
private
def set_user_time_zone
  Time.zone = current_user.time_zone if logged_in?
end

# 107 migrations
rails dbconsole
.tables
select * from schema_migrations;
.exit

change_table do |t|
  t.rename :released_on, :released_at
  t.change :description, :text, :limit => nil, :null => true
  t.remove :price
  t.integer :stock_quantity
end

#108 named scoped
in model
named_scope :cheap, :conditions => { :price => 0..5 }
Product.cheap # => output all products with price between 0 and 5
Product.cheap.count

named_scope :recent, lambda { {:conditions => ["released_at > ?", 2.weeks.ago]} }
named_scope :recent, lambda { |time| {:conditions => ["released_at > ?", time]} }
named_scope :recent, lambda { |*args| {:conditions => ["released_at > ?", (args.first||2.weeks.ago)]} }
# will evaluate only the method "recent" is called
Product.recent.cheap.count
Product.recent(6.days.ago)
c = Category.first
c.products.cheap.recent.count

named_scope :visible, :include => :category, :conditions => { 'categories.hidden' => false }
# mongoid => scope :name, where...

#109 tracking attribute changes
p.changed?
p.name_was
p.name_change
p.changed #=> array of changed fields
p.changes #=> hash of arrays

config/initializers/active_record_setting.rb
ActiveRecord::Base.partial_updates = true
p.name_will_change!

#110 gem dependencies
environment.rb
config.gem "RedCloth", :version => ">= 3.0.4"

test.rb
config.gem 'mocha'
config.gem 'Shoulda'

#111 advanced search form

rails g model search keywords:string category_id:integer min_price:decimal max_price:decimal
rails g controller searches

resources :searches
@search = Search.create!(params[:search])
redirect_to @search

def find_products
  products = Product.order(:name)
  products = products.where("name like ?", "%#{keywords}%") if keywords.present?
  products = products.where(category_id: category_id) if category_id.present?
  products = products.where("price >= ?", min_price) if min_price.present?
  products = products.where("price <= ?", max_price) if max_price.present?
  products
  # chains
end

Search.delete_all ["created_at < ?", 1.month.ago]

#112 anonymous scopes
Product.scoped(:conditions => ...).scoped(:conditions => ...)

#113 contributing to rails with git
rails.lighthouseapp.com
rake test

create database activerecord_unittest;
grant all on activerecord_unittest.* to rails@localhost;

git checkout -b newbranch

def test_with_bang
  scope = Topic.base
  scope.replied!
  scope.collect #force load shouldn't effect it
  scope.approved!
  assert_equal Topic.base.replied.approved, scope
end

rake test_mysql Test/test/cases/named_scope_test

git rebase master

git format-patch master --stdout > ~/named_scope_with_bang.diff

Ruby on Rails: Core
/

#114 endless page
gem 'will_paginate'

jQuery ->
  $(window).scroll ->
    url = $('.pagination .next_page').attr('href')
    if $(window).scrollTop() > $(document).height() - $(window).height() -50
      $('.pagination').text("Fetching more products...")
      $.getScript(url)

index.js.erb

#115 caching in rails
Rails.cache.write('date', Date.today)
Rails.cache.read('date')
Rails.cache.fetch('time') { Time.now } # read, if not present, get from block

in Category model
def self.all_cached
  Rails.cache.fetch('Category.all') { all }
end

Rails.cache.delete('Category.all')

config.cache_store = :memory_store
config.cache_store = :file_store, '/path/to/cache'
config.cache_store = :mem_cache_store, '123.456.78.9:1001', '123.456.78.9:1001'

cache = ActiveSupport::Cache.lookup_store(:mem_cache_store)
cache.fetch('time', :expires_in => 5) { Time.now }
c = Category.first
c.cache_key

sudo gem update --system

#116 selenium
test rails application through your browser
selenium-on-rails

#117 semi static pages
rails g scaffold page name permalink:string:index content:text --skip-stylesheets
resources :pages, except: :show
get ':id', to: 'page#show', as: :page
redcarpet
Liquid
high_voltage
Refinery CMS
Copycopter

#118 Liquid
template system

#119 session based model

in controller
session[:comment_ids] <<@comment.id
<%=simple_format(h(comment_content))%>
<% if session[:comment_ids] && session[:comment_ids].include?(comment.id) %>
  # edit section
<% end %>
>
def authorize
  unless session[:comment_ids] && session[:comment_ids].include?(params[:id].to_i)
   redirect_to root_url
 end 
end

user_session.rb # model not a ActiveRecord

class UserSession
  def initialize(session)
    @session = session
    @session[:comment_ids] ||= []
  end

  def add_comment(comment)
    @session[:comment_ids] << comment.id
  end

  def can_edit_comment?(comment)
    @session[:comment_ids].include? comment.id && comment.created_at > 15.minutes.ago
  end
end

ApplicationController
private
  def user_session
    @user_session ||= UserSession.new(session)
  end
  helper_method: user_session

#120 thinking sphinx
brew install sphinx
rails new foo -d mysql

gem 'mysql2'
gem 'thinking-sphinx'

class Article < ActiveRecord::Base
  belongs_to :author
  has_many :comments
  define_index do
    indexes content
    indexes :name, sortable: true # name is a reserved word, we have to use its symbol format by using colon
    indexes comments.content, as: :comment_content
    indexes [author.first_name, author.last_name], as: :author_name

    has author_id, published_at
  end
end

rake ts:index
rake ts:rebuild

def index
  # @articles = Article.search(params[:search], order: :name)
  # @articles = Article.search(params[:search], page: 1, per_page: 20)
  # @articles = Article.search(params[:search], conditions: {name: "Batman"})
  # @articles = Article.search(params[:search], with: {author_id: 2})
  @articles = Article.search(params[:search], with: {published_at: 3.weeks.ago..Time.zone.now})
  # field_weights: {name:20, content:10, author_name: 5}
  # match_mode: :boolean 
end

rake ts:reindex

Delta Indexes