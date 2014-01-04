include vs joins
c = Comment.all(:joins => :user, :conditions => { :users => { :admin => true } })
c = Comment.all(:include => :user, :conditions => { :users => { :admin => true } })
#include, create user model in the memory at the same time as fetching the comments
# loading all attributes
#using the include statement generates a much larger SQL query loading into memory all the attributes from the other table(s).
1. joins, only load id, if you need other infomation, another sql query will be executed.
2. include, load all attributes from user, no sql query will be executed, if we fetch user info 

User.all(:joins => :comments, :select => "users.*, count(comments.id) as comments_count", :group => "users.id" )

# crop the image
# carrierwave + jcrop

# gemcutter

gem update --system
gem install cutter
gem tumble
gem push yourgem-0.0.1.gem
GemSpec (rubygems.org)

gem jeweler

rake gemcutter:release

# gem 'formtastic'

# gem "exception_notification"
# gem "exception_logger"

#test_exception
scrpt/generate integration_test exceptions

# embeded association

ROLES = %[admin moderator author]
User::ROLES
1. serialize :roles
2. mask
genrate migration add_roles_mask_to_users roles_mask:integer


# Nokogiri
# Mechanize
require 'mechanize'
agent = WWW::Mechanize.new
agent.get('...')

# cancan
  
#mongo mapper
key :name, String, :required => true
schemaless database

http://rdoc.info/
http://www.runcoderun.com/
https://www.ruby-toolbox.com/
http://newrelic.com/
http://asciicasts.com/

#nested model view
accepts_nested_attributes_for :questions, allow_destroy: true

#edit multiple individually
@products = Product.update(params[:products].keys, params[:products].values).reject{ |p| p.errors.empty?}
if @products.empty?
  flash[:notice] = ...
  redirect_to products_url
else
  render :action => "edit_individual"
end

# mobile device
class ApplicationController < ApplicationController::Base
  ...

  private 
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?
end

before_filter :prepare_for_mobile

def prepare_for_mobile
  session[:mobile_param] = params[:mobile] if params[:mobile]
end

Mime::Type.register_alias "text/html", :mobile

respond_to do |format|
  format.html
  format.mobile
end

jQtouch
http://jqtjs.com/

# 201 bundler
manages an application's dependencies
'~> 2.11.2', only update if the last number changes'
gem 'rails', github: 'rails/rails', branch: '3-2-stable', ref: '123...'
gem 'capybara', group: :test

bundler help install
bundler install --without=GROUP1
bundler outdated

bundler exec # to ensure using the exact ruby gems your application depends on

bundler install --binstubs

# query 
Article.order("published_at desc").limit(10)
Article.where("published_at <= ?", Time.now).includes(:comments)
Article.order("published_at desc").first
Article.order("published_at").last

performs lazy loading
only performs (sql) query whenever necessary
Article.order("published_at") => only return "active record relational object"
@articles = Article.all # return object
in the view
<% @articles.each... %> # perform query to the database >

scope :visible, where("hidden != ?", true)
scope :published, lamda { where("published_at <= ?", Time.zone.now)}
# chain other name scope
scope :recent, visible.published.order("published_at desc")

Article.recent
Article.recent.to_sql # return sql query which is performed to database

scope :cheaper_than, lambda { |price| where("price < ?", price)}

def self.cheaper_than(price)
  where("products.price < ?", price) # string , you'd better to add table name
end

scope :cheap, cheaper_than(5)

Category.joins(:products).to_sql

Category.joins(:products) & Product.cheap
scope :with_cheap_products, joins(:products) & Product.cheap

p = Product.discontinued.build

rails/arel

#routes
resources :products do
  get :detailed, :on => :member
end

resources :forums do
  collection do
    get :sortable
    put :sort
  end
  resources :topics
end

root :to => "home#index" # root "home#index"
match "/about(.:format)" => "info#about",via: [:get, :post], :as => :about # about_path 

match "/:year/:month/:day"
match "/:year(/:month(/:day))" => "info#about", :constraints => {:year =>/\d{4}/, :month =>/\d{2}/, :day=>/\d{2}/}
match "/secret" => "info#about", :constraints => {:user_agent =>/Firefox/, :host => 'localhost'}

constraints :host => /localhost/ do
  match "/secret" => "info#about"
end

<% debug params %> 
>

#xss
<%=raw comment.content %>
"foo".html_safe?
safe = "safe".html_safe

helper_method
def strong(content)
  "<strong>#{h(content)}</strong>".html_safe
end

# block in erb
def admin_area(&block)
  # with_output_buffer(&block)
  content_tag(:div, :class => "admin", &block) if admin?
end

# validations
User.validators
User.validators_on(:email)
User.validators_on(:name)

# refactoring dynamic delegator
in Product model
def self.search(params)
  products = Product.scoped
  products.where("name like ?", "%" + params[:name] + "%") if params[:name]
  products.where("price >= ?", params[:price_gt]) if params[:price_gt]
  products.where("price <= ?", params[:price_lt]) if params[:price_lt]
  products
end

def self.scope_builder
  DynamicDelegator.new(scoped)
end

jquery-ui-rails
require jquery-ui-datepicker


# generator 
rails g
rails g scaffold --help
rails g scaffold project name:string --no-stylesheets

config.generators do |g|
  g.stylesheets false
end

group :test do
  gem "shoulda"
  gem "factory_girl"
end

# PDFKit
gem "pdfKit"

gem "wicked_pdf"

#
match "/p/:id" => redirect("/products/%{id}")

# application.rb
config.filter_parameters += [:password]

#
redirect_to @product, :notice => "Successfully created product."
redirect_to [:edit, @product], :notice => "Successfully created product."

cookies[:last_product_id] = @product.id
cookies.permanent[:last_product_id] = @product.id

respond_to :html, :xml

def index
  ...
  respond_with(@products)
end

respond_with(@product, :location => products_url)
respond_with(@product) do |format|
  format.xml { render :text => "I'm XML" }
end

rvm update
rvm reload
rvm system

Product.lte(price: 40).first
Product.gt(released_at: 1.month.ago)

embeds_many :reviews
all reviews data is within product document, not store as a separate document in the mongoDB
reviews has to be within parent documents
it doesnt perform another query when fetching embeded documents

include Mongoid::Timestamps
include Mongoid::Paranoia
include Mongoid::Versioning

field :_id, type: String, default: -> { name.to_s.parameterize }

# avatar
def avatar_url(user)
  if user.avatar_url.present?
    user.avatar_url
  else
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end
end


http://gravatar.com/avatar/23e97ec0407879af2504812d6a6157b8.png
http://gravatar.com/avatar/23e97ec0407879af2504812d6a6157b8.png?s=300
http://gravatar.com/avatar/23e97ec0407879af2504812d6a6157b8.png?d=http....
# default url

pair this with omniauth
