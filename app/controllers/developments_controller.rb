class DevelopmentsController < ApplicationController

  layout 'search', except: [:show]

  before_action :load_record, only: [:show, :image, :edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]

  def index
    @limits = Development.ranged_column_bounds.to_json
  end

  def show
    if @development.out_of_date?
      flash.now[:partial] = { path: 'developments/out_of_date' }
    end
  end

  def new
  end

  def edit
  end

  def image
    send_data @development.street_view.image, type: 'image/jpg',
      disposition: 'inline'
  end

  def export
    @search = ReportPresenter.new Search.new(query: export_params)
    respond_to do |format|
      format.pdf  { render Export::PDF.new(@search).render }
      format.html { render Export::PDF.new(@search, show_as_html: true).render }
      format.csv  { send_data *Export::CSV.new(@search).render }
    end
  end

  private

  def load_record
    @development = DevelopmentPresenter.new(Development.find(params[:id]))
  end

  def export_params
    params.permit *(Development.column_names.map(&:to_sym) + Development::FieldAliases::ALIASES.keys)
  end

end
