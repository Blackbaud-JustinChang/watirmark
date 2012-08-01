module Watirmark
  module Actions

    attr_accessor :records

    def run(*args)
      begin
        @records << @model if @records.size == 0
        before_all if respond_to?(:before_all)
        @records.each do |record|
          @model = hash_to_model(record) if Hash === record
          args.each do |method|
            before_each if respond_to?(:before_each)
            self.send(method)
            after_each if respond_to?(:after_each)
          end
        end
        after_all if respond_to?(:after_all)
      ensure
        @records = []
      end
    end

    def search_for_record
      return unless @search
      @search.new(@supermodel.find(@search.class + 'Model')).search
    end

    # Navigate to the View's edit page and for every value in
    # the models hash, verify that the html element has
    # the proper value for each keyword
    def verify
      search_for_record
      @view.edit @model
      verify_data
    end

    # Navigate to the View's edit page and
    # verify all values in the models hash
    def edit
      search_for_record
      @view.edit @model
      populate_data
    end

    # Navigate to the View's create page and
    # populate with values from the models hash
    def create
      @view.create @model
      populate_data
    end

    # Navigate to the View's create page and
    # populate with values from the models hash
    def get
      unless @view.exists? @model
        @view.create @model
        populate_data
      end
    end

    # delegate to the view to delete
    def delete
      @view.delete @model
    end

    # delegate to the view to copy
    def copy
      @view.copy @model
    end

    # delegate to the view to restore
    def restore
      @view.restore @model
    end

    # delegate to the view to archive
    def archive
      @view.archive @model
    end

    # delegate to the view to activate
    def activate
      @view.activate @model
    end

    # delegate to the view to deactivate
    def deactivate
      @view.deactivate @model
    end

    def locate_record
      @view.locate_record @model
    end

    # Navigate to the View's create page and verify
    # against the models hash. This is useful for making
    # sure that the create page has the proper default
    # values and contains the proper elements
    def check_defaults
      @view.create @model
      verify_data
    end
    alias :check_create_defaults :check_defaults


    # A helper function for translating a string into a
    # pattern match for the beginning of a string
    def starts_with(x)
      /^#{Regexp.escape(x)}/
    end

    # Return all of the text in a browser. :TODO: remove
    def verify_contains_text
      @browser.text
    end

    # Stubs so converted XLS->RSPEC files don't fail
    def before_all; end
    def before_each; end
    def after_all; end
    def after_each; end
  end
end