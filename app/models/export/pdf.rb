class Export::PDF

  def initialize(record, filename: :id, title: :title, **options)
    @record   = record
    @filename = @record.send(filename).to_s
    @title    = (@record.send(title) || 'Development Export').to_s
    @config   = default_config.merge(options)
  end

  def render
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
