#121   non-active-record-model
class Letter
  attr_reader :char

  def self.all
    ('A'..'Z').map {|c| new(c)}
  end

  def self.find(param)
    all.detect {|l| l.to_param == param} || raise(ActiveRecord::RecordNotFound)
  end

  def initialize(char)
    @char = char
  end

  def to_param
    @char.downcase
  end

  def products
    product.find(:all, :conditions => ["name LIKE ?", @char + '%'], :order => "name")
  end
end

#122 passenger
sudo passenger-install-apache2-module
passenger-prepane
sudo apachectrl graceful

#123 subdomains
# match '', to: 'blog#show', constraints: {subdomain: /.+/}
match '', to: 'blog#show', constraints: lambda {|r| r.subdomain.present? && r.subdomain != "www"}
root to: 'blog#index'

def show
  @blog = Blog.find_by_subdomain!(request.subdomain)
end

root_url(subdomain: blog.subdomain)
config.action_dispatch.tld_length = 2 # top level domain name 

#124 beta invitation
class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'
end

class User < ActiveRecord::Base
  has_many :sent_invitation, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
end

token generation
def generate_token
  self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
end

def decrement_sender_count
  sender.decrement! :invitation_limit
end

Mailer.deliver_invitation(@invitation, signup_url(@invitation.token))

def invitation_token
  invitation.token if invitation
end

def invitation_token=(token)
  self.invitation = Invitation.find_by_token(token)
end

#125 dynamic layout
create an column for blogs
rails g migration add_layout_to_blogs layout_name:string custom_layout_content:text

in controller
layout :blog_layout

def blog_layout
  @current_blog.layout_name
end

in ApplicationController
self.class.layout(@current_blog.layout_name || 'application')

#126 populating a database
gem install populator
gem install faker

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [Category, Product, Person].each(&:delete_all)

    Category.populate 20 do |category|
      category.name = Populator.words(1..3).titleize
      Product.populate 10..100 do |product|
        product.category_id = category.id
        product.name        = Populator.words(1..5).titleize
        product.description = Populator.sentences(2..10)
        product.price       = [4.99, 19.95, 100]
        product.created_at  = 2.years.ago..Time.now
      end
    end

    Person.populate 100 do |person|
      person.name    = Faker::Name.name
      person.company = Faker::Company.name
      person.email   = Faker::Internet.email
      person.phone   = Faker::PhoneNumber.phone_number
      person.street  = Faker::Address.street_address
      person.city    = Faker::Address.city
      person.state   = Faker::Address.us_state_abbr
      person.zip     = Faker::Address.zip_code
    end
  end
end

rake db:populate

#127 rake in background
lib/tasks/mailer.rake
desc "Send mailing"
task :send_mailing => :environment do 
  mailing = Mailing.find(ENV["MAILING_ID"])
  mailing.deliver
end

in the controller
def deliver
  # system "rake send_mailing MAILING_ID=#{params[:id]} &"
  call_rake :send_mailing, :mailing_id => params[:id]
end

def call_rake(task, option={})
  options[:rails_env] = Rails.env
  args = options.map {|n, v| "#{n.to_s.upcase}='#{v}'"}
  system "rake #{task} #{args.join(' ')} --trace >> #{Rails.root}/log/rake.log &"
  # /usr/bin/rake
end

Rake in background ideal for:
- infrequent tasks
- long processes
- strict access

#128 starling and workling
gem "starling" # a server

#129 custom daemon

BackgroundJob (BJ)
BackgroundDRb
Background Fu

gem install daemons
plugin daemon_generator

#130 monitoring with god
gem install god

spawnling

#131 going back
redirect_to :back
redirect_to request.env['HTTP_REFERER']
session[:last_product_page] = request.env["HTTP_REFERER"] || products_url

#132 helpers outside views
in Category model
def description
  "This category has #{helpers.pluralize(products.count, 'product')}"
end

def helpers
  ActionController::Base.helpers
end

#133 capistrano
#134 paperclip
#135 making a gem -- out of date
#136 ujs, remote, run script
respond_to do |format|
  format.html { redirect_to ...}
  format.js
end

#137 memoization
@filesize = calculate_filesize unless defined? @filesize
@filesize ||= calculate_filesize 

def filesize(*args)
  @filesize ||= {}
  @filesize[args] ||= calculate_filesize(*args)
end

gem memoist

#138 I18n
#139 nested resources
# resources :articles do |article|
#   article.resources :comments
# end
resources :articles, :has_many => :comments
resources :articles, :has_many => :comments, :shallow => true

article_comments_path(:article_id => @article)
new_article_comment_path(@article)
@comment = @article.comments.find(params[:id])

#140 rails 2.2
Product.all(:joins => :category, :conditions => { :categories => {:name => 'Clothing'}})
Product.find_last_by_price('4.99')

#141 paypal 142 paypal notification 143 security
sandbox
developer.paypal.com
cart(our server) -> billing info(PayPal) -> Purchase (Payment Notification) ->Receipt -> Back to Site

protect_from_forgery 
This will automatically include a security token, calculated from the current session and the server-side secret, in all forms and Ajax requests generated by Rails.

serialize :params

openssl genrsa -out app_key.pem 1024
openssl req -new -key app_key.pem -x509 -days 365 -out app_cert.pem

#144 active merchant
#145 paypal express 