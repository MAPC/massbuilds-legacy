module ApplicationHelper
	def present(object, klass = nil)
	  # if a klass isn't specified determine the class based off the object 
	  # klass (bids presenter, user presenter etc)
	  klass ||= "#{object.class}Presenter".constantize
	  # instantiate presenter
	  presenter = klass.new(object, self)
	  # yield presenter if a block is given
	  yield presenter if block_given?
	  # return presenter back from the method
	  presenter
	end
end
