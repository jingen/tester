class Project
  include Mongoid::Document
  # include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  has_many :issues
  before_destroy :remove_issues
  validates_presence_of :name

  has_one :timeline, as: :timelineable

  protected 
  def remove_issues
    self.issues.delete_all
  end
end
