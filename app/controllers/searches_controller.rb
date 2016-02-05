class SearchesController < ApplicationController

  before_action :load_record
  before_action :ensure_saved_search

  def show
    render pdf: "#{@search.id}",
         title: "#{@search.title}",
         show_as_html: params[:format] == 'html',
             template: 'searches/show.html.haml'
  end

  private

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
