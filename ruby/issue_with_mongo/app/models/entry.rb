class Entry
  include Mongoid::Document
  field :name, type: String
  field :winner, type: Boolean

  def as_json(options={})
    {
      id: self.id.to_s,
      name: self.name,
      winner: self.winner
    }
  end
end
