class SearchesController < ApplicationController

  before_action :load_record
  before_action :ensure_saved_search

  def show
    respond_to do |format|
      format.pdf  { render Export::PDF.new(@search).render }
      format.html { render Export::PDF.new(@search, show_as_html: true).render }
      format.csv  { send_data *Export::CSV.new(@search).render }
    end
  end

  private

  def load_record
    @search = ReportPresenter.new(Search.find(params[:id]))
  end

  # TODO: Refactor
  def ensure_saved_search
    search = @search.item
    if search.unsaved?
      search.saved = true
      search.save!
    end
  end
end
