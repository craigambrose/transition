class MapRegionsController < ApplicationController
  before_filter :load_map_region, :only => :show
  
  def show
  end
  
  protected
  
    def load_map_region
      @map_region = MapRegion.find(params[:id])
    end

    def title
      "Resources for Resiliance - #{@map_region.name}"
    end
  
end
