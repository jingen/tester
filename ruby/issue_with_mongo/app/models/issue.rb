class Issue
  include Mongoid::Document
  include Mongoid::Paperclip
  # include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :no_followers, type: Integer

  has_mongoid_attached_file :image,
                            :styles => { :small => "150x150#"},
                            # :url => "/assets/issues/:id/:style/:basename.:extension",
                            :url => ':s3_alias_url',
                            :path => ":rails_root/public/assets/issues/:id/:style/:basename.:extension"

  belongs_to :project
  validates_presence_of :title

  has_one :timeline, as: :timelineable
  after_save :add_to_timeline

  private

  def add_to_timeline
    self.timeline = Timeline.new(content:"An issue was created!");
  end

end

