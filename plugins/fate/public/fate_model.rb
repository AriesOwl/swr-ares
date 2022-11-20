module AresMUSH
  class Character < Ohm::Model
    attribute :fate_hc, :type => DataType::Array, :default => []
    attribute :fate_tr, :type => DataType::Array, :default => []
    attribute :fate_ori, :type => DataType::Array, :default => []
    attribute :fate_aspects, :type => DataType::Array, :default => []
    attribute :fate_stunts, :type => DataType::Hash, :default => {}
    attribute :fate_skills, :type => DataType::Hash, :default => {}
    attribute :fate_PStress, :type => DataType::Array, :default => []
    attribute :fate_points, :type => DataType::Integer
    attribute :fate_refresh, :type => DataType::Integer
  end
end