#61 sending email
rails g mailer user_mailer signup_confirmation

class UserMailer < ActionMailer::Base
  default from: "Jingen.lin.jl@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end
end

config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: "linjingen.com", #"railscasts.com"
  authentication: "plain",
  enable_starttls_auto: true,
  user_name: "jelinmscs@gmail.com",
  password: "83681600lje.",
  openssl_verify_mode: 'none'
}

in the mail view
  user_url(@user)
  #need to set host option
  config.action_mailer.default_url_options = {host: "localhost:3000"}
# gem "letter_opener"
# config.action_mailer.delivery_method = :letter_opener

#62 hacking active record
class Product < ActiveRecord::Base
  validates_presence_of :price

  def self.find_ordered
    #find(:all, :order => 'name')
    order('name').all
  end
end

disable_validation do
  ... 
end

in test_helper.rb
def disable_validation
  ActiveRecord::Base.disable_validation!
  yield
  ActiveRecord::Base.enable_validation!
end

module ValidationDisabler
  def self.included(base)
    base.class_eval do
     extend ClassMethods 
     alias_method_chain :valid?, :disable_check
     @@disable_validation = false
    end
  end

  # def valid?
  #   true
  # end
  def valid_with_disable_check? # alias_method_chain
    if self.class.validation_disabled?
      true
    else
      valid_without_disable_check?
    end
  end

  module ClassMethods # class methods instead of instance method
    def disable_validation!
      @@disable_validation = true
    end
    def enable_validation!
      @@disable_validation = false
    end
    def validation_disabled?
      @@disable_validation
    end
  end
end

class ActiveRecord::Base
  include ValidationDisabler
end

#63 model name in URL
+1 gem friendly_id
+2 override to_param

Class Page < ActiveRecord::Base
#...
  def to_param #by default, going to return the id.
    "#{id}-#{name}".parameterize
  end
end
"7-product-categories".to_i # => 7

rails g migration add_slug_to_pages slug:index
rake db:migrate
in page.rb
validates :slug, uniqueness: true, presence: true, exclusion: {in: %w[signup login]}
before_validation :generate_slug
def to_param
  slug
end
def generate_slug
  self.slug ||= name.parameterize
end

Page.find_each(&:save)

contoller:
  @page = Page.find_by_slug!(params[:id].split("/").last)

resources :pages, only: [:index, :new, :create]
resources :pages, path: "", except: [:index, :new, :create]
get '*id', to: 'page#show'

def nested_page_path(page)
  "/" + (page.ancestors + [page]).map(&:to_param).join("/")
end

#64 helper
app/helpers/formatting_helper.rb
module FormattingHelper
  def my_helper
    ...
  end
end

class ApplicationController < ApplicationController::Base
  ...
  helper :formatting, :authentication, :path
  # helper :all
end

#65 Akismet, stop spam
#66 custom rake tasks
rake -T # list available tasks

/lib/tasks/jingen.rake
task :greet do
  puts "Hello World!"
end

task :ask => :greet do # greet will be run before ask
  puts "How are you?"
end

rake greet
rake ask

task :pick_issue => :environment do
  issue = Issue.first
  puts "Selected Issue is #{issue.name}"
end
uninitialized constant user # not loading environment

namespace :issue do
  task :greet do
    puts "Hello World!"
  end

  task :ask => :greet do
    puts "How are you?"
  end

  desc "Pick the first issue in the database"
  task :first => :environment do
    issue = Issue.first
    puts "Selected Issue is #{issue.name}"
  end

  task :last => :environment do
    issue = Issue.last
    puts "Selected Issue is #{issue.name}"
    # puts "Prize: #{pick(Product).name}"
  end

  task :all => [:first, :last]
  def pick(model_class)
    model_class.find(:first, :order => 'RAND()')
  end
end
rake issue:first
rake issue:all

#67 restful_anthentication
#68 openID
gem ruby-openid
#69 markaby in helper ( an html generator )
+ render :partial => 'shared/error_messages', :locals => {...}
+ content_tag

#70 routes
map.connect 'articles/:year/:month/:day', :controller => "articles", :month => nil, :day => nil, :requirements => { :year => /\d{4}/ }
(match)

#71 rspec
#testing for controller only
#spec_helper.rb
config.mock_with :mocha

#72 environment
config.cache_classes = true

staging.rb
config.log_level = :debug

database.yml
staging:
  adapter: sqlite3
  database: db/staging.sqlite3
  pool: 5
  timeout: 5000

rails s -e stagingg
rails c staging
alternatives:
RAILS_ENV=staging rails s
RAILS_ENV=staging rake ...
export RAILS_ENV=staging 

group :staging do # only required in staging environment
  gem "ruby-prof"
end
+ config/application.rb
Bundler.rquire(*Rails.groups(:assets => %w(development test)))

#73 - 75 complex form
<% fields_for "project[task_attributes][]", task do |task_form| %> #... is the prefix
  <p>
    Task: <%= task_form.text_field :name %>
  </p>
<% end %>

def task_attributes=(task_attributes)
  task_attributes.each do |attributes|
    tasks.build(attributes)
  end
end

<%= render :partial => 'task', :collection => @project.tasks, :as => :item%>
# without as, @project.tasks pass in as task by default
_task.html.erb

#76 scope out
scope_out :incomplete, :conditions => ['complete=?', false], :order => 'name'
Task.with_incomplete do
  @tasks = Task.find(:all)
end
has_many :tasks, :extend => Task::AssociationMethods # caching

#77 destroy
<%link_to "Destroy", product, method: :delete, data: {confirm: "Are you sure?"}%>
# <a href="/products/1" data-confirm="Are you sure?", data-method="delete" rel="nofollow">Destroy</a>
# using jquery_ujs.js to get the "destroy" done
# <%= link_to "Destroy", [:delete, product] %>
button_to
in routes
member/collection

resources :products do #project/:id
  member do
    get :delete
    delete :delete, action: :destroy
  end
end

match "cars/:id/similar" => "cars#similar", :via => "get"

@product = Product.find(params[:id])
@product.destroy
redirect_to products_url, notice: "Product was destroyed"

initializer
module DeleteResourceRoute
  def resources(*args, &block)
    super(*args) do
      yield if block_given?
      member do
        get :delete
        delete :delete, action: :destroy
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, DeleteResourceRoute)

#78 pdf writer gem

#79 named routes
resources :product, :categories
products_path, categories_path
about_company 'about/company', :controller => 'about', :action => 'company'

def map.controller_actions(controller, actions)
  actions.each do |action|
    self.send("#{controller}_#{action}", "#{controller}/#{action}", :controller => controller, :action => action)
  end
  map.controller_actions 'about', %w[company privacy license]
end

#80 simplify views
<%= render :partial => 'product', :collection => @products %>
# <%= render :partial => @products %>
<%= render :partial => 'product', :object => @product %>
# <%= render :partial => @product %>
<%= link_to h(product.name), product_path(product) %>
div_for
<%form_for @product do |f|%>
<%end%>

#81 fixtures (test/fixtures)
fixtures for the product model
in products.yml
couch:
  # id: 1
  name: Couch
  price: 399.99
  # manufacturer_id: 1
  manufacturer: lazyboy
  categories: furniture
  #created_at: <%= Time.now %>
  #updated_at: <%= Time.now %>

tv_stand:
  # id: 2
  name: TV Stand
  price: 149.95
  # manufacturer_id: 2
  manufacturer: highdeph
  categories: furniture, electronics
  #created_at: <%= Time.now %>
  #updated_at: <%= Time.now %>

manufacturers.yml
lazyboy:
  name: LazyBoy

highdeph:
  name: HighDeph

categories.yml
fixture:
  name: Fixture
electronics:
  name: Electronics

rake db:test.load
rake db:test:prepare
rake test test/models/post_test.rb test_method_name

#82 http basic authentication
in controller
before_filter :authenticate

protected
def authenticate
  authenticate_or_request_with_http_basic do |username, password|
    username == "foo" && password == "bar"
  end
end

#83 migration
rake db:create # for current environment
rake db:create:all # for all environment

***_create_tasks.rb
t.integer :priority, :position
rake db:migrate
rails g migration add_description_to_task description:text
# naming convention "add...to..."
rails g migration remove_description_from_task description:text

#84 cookie based session store
limited space
possible for the user to see the contents of the session
more bandwidth

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_store_session',
    :secret => 'longlongstring'
  }
end

#85 yaml configuration file

in config/environment.rb
# USERNAME = 'admin'
# PASSWORD = 'secret'
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/appconfig.yml")[RAILS_ENV]

in config/appconfig.yml
development:
  perform_authentication: false
test:
  perform_authentication: false
production:
  perform_authentication: true
  username: admin
  password: secret

in the code
if APP_CONFIG['perform_authentication']
  .....
  username = APP_CONFIG['username']
end

initializers folder
load_config.rb
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/appconfig.yml")[RAILS_ENV]
######################

http_basic_authenticate_with name: ENV["BLOG_USER"], password: ENV["BLOG_PASSWORD"], except: [:index, :show]
in apllication.yml
BLOG_USER: "admin"
BLOG_PASSWORD: "secret"
development:
  MAILER_HOST: "localhost:3000"
test:
  MAILER_HOST: "localhost:3000"
production:
  MAILER_HOST: "localhost:3000"
echo /config/application.yml >> .gitignore
cp config/application.yml config/application.example.yml
in config/application.rb

CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!
username: "admin"
CONFIG[:username]
# config YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
# config.merge! config.fetch(Rails.env, {})
# config.each do |key, value|
#   ENV[key] = value.to_s unless value.kind_of? Hash
# end


#figaro

#86 logging variables
logger.debug "Year: #{year} Month #{month}"
logger.debug_variables(binding)

in config/initializers/logger_additions.rb
logger = ActiveRecord::Base.logger

# binding, eval
# eval('local_variable', binding)
def logger.debug_variables(bind)
  vars = eval('local_variable + instance_variables', bind)
  vars.each do |var|
    debug "#{var} = #{eval(var, bind).inspect}"
  end
end

#87 generating rss feeds
def index
  ...
  # respond_to do |format|
  #   format.html
  #   format.atom
  # end
end
index.atom.builder
atom_feed do |feed|
  feed.title "Superhero Articles"
  feed.updated @articles.maximum(:updated)
  @articles.each do |article|
    feed.entry article, publiced: article.publiced_at do |entry|
      entry.title article.name
      entry.content article.content
      entry.author do |author|
        author.name article.author
      end
    end
  end
end
curl http://localhost:3000/articles.atom | pbcopy
validator.w3.org
auto_discovery_link_tag
index.rss.builder

#88 dynamic select menus
<% f.grouped_collection_select :state_id, Country.order(:name), :states, :name, :id, :name, include_blank: true %> %>
javascript to filter

#89 page caching
config.action_controller.perform_caching = true
in controller
caches_page :index, :show
before_filter(only: [:index, :show]){@page_caching = true}
cache_sweeper :product_sweeper

csrf_meta_tag unless @page_caching
unless @page_caching
 # flash msg 
end

in routes.rb
get 'products/page/:page', to: 'products#index'

/app/sweepers/product_sweeper.rb
class ProductSweeper < ApplicationController::Caching::Sweeper
  observe Product
  def sweep(product)
    expire_page products_path
    expire_page product_path(product)
    expire_page "/"
    FileUtils.rm_rf "#{page_cache_directory}/products/page"
  end
  alias_method :after_update, :sweep
  alias_method :after_create, :sweep
  alias_method :after_destroy, :sweep
end

#90 fragment caching
<% cache "recent_articles" do %>
  # ....
<% end %>

expire_fragment("recent_articles")

<% cache @article do %>
  ...
<% end %>
# @article.cache_key

class Comment < ActiveRecord::Base
  belongs_to :article, touch: true
end
# when comments change, article will change

Rails.cache.read('views/recent_articles')
config.cache_store = :mem_cache_store