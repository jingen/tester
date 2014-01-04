class Timeline
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :timelineable, polymorphic: true
end
