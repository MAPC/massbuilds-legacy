class ProposedEdit < Form

  def initialize(item, options={})
    @item = item
    @options = options
  end

  # Trick form helpers into using the developments path
  def self.model_name
    ActiveModel::Name.new(self, nil, "Development")
  end

  def new_record?
    false
  end

  def item
    @item || Development.new
  end

  delegate(*Development.attribute_names, to: :item)
  delegate :private, :affordable, to: :item

  private

    def persist!
      edit = Edit.create(editor: current_user, development: item)
      item.changes.each_pair do |name, diff|
        edit.fields.create(
          name: name, change: { from: diff.first, to: diff.last }
        )
      end
    end

    def current_user
      @options.fetch(:current_user) {
        raise ArgumentError, "Need a current_user to persist form in #{__FILE__}."
      }
    end

end
