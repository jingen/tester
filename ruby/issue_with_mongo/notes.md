================
# Dynamic fields

##If the attribute does not already exist on the document, Mongoid will not provide you with the getters and setters and will enforce normal method_missing behavior. In this case you must use the other provided accessor methods: ([] and []=) or (read_attribute and write_attribute).
##Dynamic attributes can be completely turned off by setting the Mongoid configuration option allow_dynamic_fields to false.
# Raise a NoMethodError if value isn't set.'
person.gender
person.gender = "Male"

# Retrieve a dynamic field safely.
person[:gender]
person.read_attribute(:gender)

# Write a dynamic field safely.
person[:gender] = "Male"
person.write_attribute(:gender, "Male")

================
# show all the record, like Issue.all
Category.all.each do |test|
  puts test.inspect
end

================
Dirty Tracking

class Person
  include Mongoid::Document
  field :name, type: String
end

person = Person.first
person.name = "Alan Garner"

# Check to see if the document has changed.
person.changed? #=> true

# Get an array of the names of the changed fields.
person.changed #=> [ :name ]

# Get a hash of the old and changed values for each field.
person.changes #=> { "name" => [ "Alan Parsons", "Alan Garner" ] }

# Check if a specific field has changed.
person.name_changed? #=> true

# Get the changes for a specific field.
person.name_change #=> [ "Alan Parsons", "Alan Garner" ]

# Get the previous value for a field.
person.name_was #=> "Alan Parsons"

Resetting changes

You can reset changes of a field to its previous value by calling the reset method.

person = Person.first
person.name = "Alan Garner"

# Reset the changed name back to the original
person.reset_name!
person.name #=> "Alan Parsons"

Viewing previous changes

After a document has been persisted, you can see what the changes were previously by calling Model#previous_changes

person = Person.first
person.name = "Alan Garner"
person.save #=> Clears out current changes.

# View the previous changes.
person.previous_changes #=> { "name" => [ "Alan Parsons", "Alan Garner" ] }

Mongoid uses dirty tracking as the core of its persistence operations. It looks at the changes on a document and atomically updates only what has changed unlike other frameworks that write the entire document on each save. If no changes have been made, Mongoid will not hit the database on a call to Model#save.

===============

Getting Started

+1
    rails g controller issues index
    #rails d controller issues index
    rails g model issue

+2
    render 'form' in issues/edit.html.erb
    issues/_form.html.erb

+3
    Issue.all #return object storing all records
    issue = Issue.find(params[:id])
    issue.update(issue_params)
###
    def issue_params
        params.require(:issue).permit(:title, :description, :no_followers)
    end
### 

+4 
    rails g controller project index
    rails g model project

+5
    comment application.js or application.css using //
    //= //require_tree .

    in the layout file, "application.html.erb"

    <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
    ###### using params[:controller]
    <%= stylesheet_link_tag params[:controller], media: "all", "data-turbolinks-track" => true %>
    <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
    ###### using params[:controller]
    <%= javascript_include_tag params[:controller], "data-turbolinks-track" => true %>
    <%= csrf_meta_tags %>

+6
    Project: has_many(or has_one)
    Issue: belongs_to

    project = Project.new(name: "openassembly", description: "great")
    project.save
    project.issues << Issue.new(title: "database") #issues is saved in the database, only if project has been persisted in the database
    (has_one: project.issue = Issue.new(title: "database")) #issue is saved in the db

    issue = Issue.new(title: "computer")
    issue.project = Project.new (but has been not saved)
    issue.project.save

    > Issue.all.each do |i| project.issues.push(i) end;0

    #####polymorphic
    rails g model timeline

    In class Issue

    has_one :timeline, as: :timelineable #############
    after_save :add_to_timeline

    private

    def add_to_timeline
        self.timeline = Timeline.new(content:"An issue was created!"); ############ automatically save in db
    end

    In class Timeline

    belongs_to :timelineable, polymorphic: true


rails with mongo

User.fields.keys
User.all.entries
User.all.update_all
