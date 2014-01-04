render nothing: true

Product.find_in_batches(batch_size: 10) { |batch| puts batch.size }
Product.each(:batch_size => 10) { |product| puts product.name }
Product.scoped_by_price(4.99).size
Product.scoped_by_price(4.99).scoped_by_category_id(3).first

in Product model
default_scope :conditions => ["price = ?", 4.99]
default_scope :conditions => "deleted_at is null"
Product.count # where (price = 4.99)
defautl_scope :order => "name"
Product.find_by_price(4.95).try(:name) # name method doesn't exist

# <%= render :partial => 'product', collection => @products %>  >
# <%= render :partial => @products %> >
# <%= render @products %> >
method "render" in controller and views are different.
in the controller, the templates are passed in
in the same directory, there is a new.html.erb
render "new" 
in the product directory, there is a edit.html.erb
render "products/edit" 
in the view,
_new.html.erb
_edit.html.erb

#153 pdf prawn

link_to "Printable Recept (PDF)", order_path(@order, format: "pdf")

cucumber - behavior driven test framework
webrat, capybara
Rspec (matchers, macros)

rake spec
rake cucumber

factory_girl # create(database), build
group :test do
  gem "capybara"
  gem "factory_girl_rails"
end

config.include Factory::Syntax::Methods

authlogic

acts_at_authentic

gem "ancestry" 

self referential association

# host 
# Morris.js : graph
# rickshaw
# highcharts

# OmniAuth

#279 asset pipeline
Rails.application.config.assets.paths
bundle open jquery-rails
www.linjingen.com/assets/myjsfile.js

in application.js
//= require_directory .
//= require_tree ./public

rake assets:precompile
#341 asset pipeline in production

rake middleware
# in development mode
# use ActionDispatch::Static   # serve static files in the public directory
rake middleware RAILS_ENV=production
# in production mode ... there is no "use ActionDispatch::Static"


=======
# whenever, crob job

set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"

every 15.minutes do
  command "rm '#{path}/tmp/cache/foo.txt'"
  script "generate_report"
end

every :sunday, at "4:28 AM" do
  runner "Cart.clear_abandoned" # load ruby environment and run ruby code
end

every :reboot do
  rake "ts:start"
end

bundle exec whenever

#alternative : gem resque-scheduler, rufus-scheduler, clockwork

#multiple edit
product[]
Product.update_all({discontinued: true}, {id: params[:product_ids]})
redirect_to products_url
redirect_to root_url

edit_multiple_products_path

resources :products do
  collection do
    get :edit_multiple
    post :update_multiple
  end
end

def edit_multiple
 @products = Product.find(params[:product_ids]) 
end

def update_multiple
  @products = Product.update(params[:products].keys, params[:products].values)
  @products.reject! { |p| p.errors.empty? }
  if @products.empty?
    redirect_to products_url
  else
    render "edit_multiple"
  end
end

@products.reject! do |product|
  product.update_attributes(params[:product].reject { |k,v| v.blank? })
end

# metric_fu
# virtual attributes
 
many to many

model tag
model article

generate model tagging article_id:integer tag_id:integer

class tagging < ActiveRecord::Base
  belongs_to tag
  belongs_to article
end

class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :articles, :through => :taggings
end

class Article < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  attr_writer :tag_names
  after_save :assign_tags

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  private

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end


# RSS feed, gem feedzirra
# dynamic page caching
caches_page :index
config.action_controller.perform_caching = true

jquery ->
  if $('#products').length
    $.getScript('/users/current')

def show
end
show.js.erb
<% if admin? %>
  $('.admin').show();
<% end %>       

$('#container').prepend('<%= j render("layouts/dynamic_header") %>')

<%= csrf_mata_tag unless @page_caching %>
<% render 'layouts/dynamic_header' unless @page_caching %>
>
def index
 @page_caching = true 
 ....
end

#delayed_job
gem "delayed_job_active_record"
gem 'delayed_job_mongoid'
#If you are using the protected_attributes gem, it must appear before delayed_job in your gemfile.

rails generate delayed_job:active_record
rake db:migrate

rake jobs:work

#@newsletter.delay.deliver
Newsletter.delay.deliver(params[:id])

class Newsletter < ActiveRecord::Base
  def self.deliver(id)
    find(id).deliver
  end

  def deliver
    sleep 10
    update_attribute(:deliver_at, Time.zone.now)
  end
end

Newsletter.delay(queue: "newsletter", priority: 20, run_at: 5.minutes.from_now)

delayed_job_config.rb #initializers
Delayed::Worker.max_attempts = 5
Delayed::Worker.delay_jobs = !Rails.env.test?

in production

gem 'daemons' # needed
gem 'delayed_job_mongoid'

delayed_job start
delayed_job stop
#delayed_job_web
# touch and cache, updated_at
# screen scraping with scrapi, Quark

# pagination with ajax
$.getScript(...)

# ajax history and bookmark
YUI, SWFADDRESS
jQuery Address

jQuery URL Utils plugin

# gem searchlogic
ActiveRecord::Base.logger = Logger.new(STDOUT)
Product.name_like("Video")
Product.name_not_like("Video")
Product.name_not_like("Video").price_gt(5)

# model versioning
#vestal_versions
paper_trail

security tips
1. mass assignments (even association attributes)
2. file upload
has_attached_file :photo
validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
3. filter log params
in ApplicationController < ApplicationController::Base
filter_parameter_logging :password

4. CSRF Protection
protect_from_forgery # :secret => '.....'

5. Authorizing ownership
def show
  @project = current_user.projects.find(params[:id])
end

6.SQL injection
where("name like ?", "%#{params[:search]}") 
User.where(name: /bob/) # mongoid

7.HTML injection # prevent cross site scripting
in the view file (.erb)
<% h task.name %> # all the html content is escaped. 
<% sanitize task.name %> # whitelist certain text like bold or italian

after Rails 3, h is not neccessary

#seed

["Windows", "Linux", "Mac OS X"].each do |os|
  OperatingSystem.find_or_create_by_name(os)
end

require 'open-uri'
Country.delete_all
open("http://.....") do |countries|
  countries.read.each_line do |country|
    code, name = country.chomp.split("|")
    Country.create!(:name => name, :code => code)
  end
end

operating_systems.yml

windows:
  name: Windows

mac:
  name: Mac OS X

linux:
  name: Linux

require 'active_record/fixtures'

Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "operating_systems")

rake db:seed

gem "seed-fu"

# 180 find unused css

Dust-Me Selectors (firefox add-on)

gem deadweight
deadweight.rake

begin
  require 'deadweight'
rescue LoadError
end

desc "run deadweight CSS check (require script/server)"
task :deadweight do
  dw = deadweight.new
  dw.stylesheets = ["/stylesheets/application.css"]
  dw.pages = ["/"] ### /aboutus ...
  dw.ignore_selectors =/flash_notice|flash_error|..../
  puts dw.run
end
rake deadweight


f = File.new("debug.log")
f.each { |line| puts line }

real  21m58.868s
user  0m7.148s
sys 0m10.817s

f = File.new("debug.log")
f.read.each_line { |line| puts line }

real  12m35.091s
user  0m6.880s
sys 0m11.029s