class SearchesController < ApplicationController

  before_action :load_record
  before_action :ensure_saved_search

  def show
    respond_to do |format|
      format.pdf  { render pdf_options }
      format.html { render pdf_options.merge({ show_as_html: true }) }
      format.csv  { send_data @search.to_csv, type: Mime::CSV,
        disposition: disposition }
    end
  end

  private

  def pdf_options
    { pdf:   @search.id.to_s,
      title: @search.title.to_s,
      template: 'searches/show.html.haml' }
  end

  def disposition
    "attachment; filename=#{@search.title.parameterize}.csv"
  end

  def load_record
    @search = ReportPresenter.new(Search.find(params[:id]))
  end

  def ensure_saved_search
    search = @search.item
    if search.unsaved?
      search.saved = true
      search.save!
    end
  end
end
