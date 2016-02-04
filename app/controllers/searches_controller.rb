class SearchesController < ApplicationController
  def show
    @search = ReportPresenter.new Search.find(params[:id])
    # TODO
    #   Add name to search, with a placeholder
    #     'Saved Search #user.searches(where: saved).count + 1'
    # render pdf: "#{@search.name}"
  end
end
