class DevelopmentsController < ApplicationController

  layout 'search', only: [:index, :new]

  before_action :load_record, only: [:show, :image, :edit]
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

  def update
    @development = Development.find params[:id]
    # TODO: Update params
    log_entry = params[:development][:log_message]
    @development.assign_attributes update_params
    # Turn assigned changes on Development into Edits
    Services::Edit::Extractor.new(@development, current_user, log_entry).call
    # TODO: Get this working, then do the log message
    flash[:partial] = { path: 'developments/proposed_success' }
    redirect_to @development
  end

  def image
    send_data *@development.street_view.sendable_data
  end

  def export
    @search = ReportPresenter.new Search.new(query: export_params)
    respond_to do |format|
      format.pdf  {
        render Export::PDF.new(@search).render
      }
      format.html {
        render Export::PDF.new(@search, show_as_html: true).render
      }
      format.csv  {
        send_data *Export::CSV.new(@search).render
      }
    end
  end

  private

  def load_record
    @development = DevelopmentPresenter.new(Development.find(params[:id]))
  end

  def export_params
    params.permit *(
      Development.column_names.map(&:to_sym) +
        Development::FieldAliases::ALIASES.keys
    )
  end

  def update_params
    params.require(:development).permit *(
      Development.column_names.map(&:to_sym) +
        Development::FieldAliases::ALIASES.keys +
          [:log_message]
    )
  end

end
