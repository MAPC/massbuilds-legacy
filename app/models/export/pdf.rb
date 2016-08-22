class Export::PDF

  def initialize(record, filename: :id, title: :title, **options)
    @record   = record
    @filename = @record.send(filename).to_s
    @title    = (@record.send(title) || 'Development Export').to_s
    @config   = default_config.merge(options)
  end

  def render
    # Generate summary statistics here, using find_in_batches with a smallish
    # batch size. This -- well, the view -- is where memory bloat appears to
    # happen the most. Then, use the summary stats in the view.
    @config
  end

  def default_config
    {
      pdf:      @filename,
      title:    @title,
      layout:   'pdf',
      template: 'searches/show.html.haml',
      header: { right: '[page] of [topage]', font_size: 9 },
      footer: {
        # TODO: MAPC Logo
        left:  "Generated on #{Time.now.to_s(:timestamp)}",
        right: 'mapc.org',
        font_size: 9
      }
    }
  end

end
