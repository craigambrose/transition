# == Schema Info
# Schema version: 20090303034616
#
# Table name: region_vertices
#
#  id         :integer(4)      not null, primary key
#  region_id  :integer(4)      not null
#  lat        :float
#  long       :float
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime

class RegionVertex < ActiveRecord::Base
  belongs_to :region, :foreign_key => :region_id
  acts_as_list :scope => :region_id
  composed_of :latlong, :mapping => [%w(long long), %w(lat lat)], :class_name => Math::Latlong.name {|vertex| Math::Latlong.new(vertex.long, vertex.lat) }
  
  validates_presence_of :region, :lat, :long
  validates_associated :region
end
