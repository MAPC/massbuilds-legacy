class API::SearchesController < ApplicationController
  def limits
    render json: Development.ranged_column_bounds.to_json
  end
end
