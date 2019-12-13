module PkiExpress
  class PadesPageOptimization
    attr_reader :custom_paper_size, :paper_size, :page_orientation

    def initialize(paper_size=nil, custom_paper_size=nil)
      @page_orientation = PadesPageOrientation::AUTO
      if custom_paper_size
        @paper_size = PadesPaperSize::CUSTOM
        @custom_paper_size = custom_paper_size
      else
        @paper_size = paper_size
      end
    end

    def custom_paper_size=(value)
      @custom_paper_size = value
      @paper_size = PadesPaperSize::CUSTOM
    end

    def paper_size=(value)
      unless PadesPaperSize.contains?(value)
        raise 'The provided "paper_size" is not valid. Try using PadesPaperSize constants'
      end
      @paper_size = value
    end

    def page_orientation=(value)
      unless PadesPageOrientation.contains?(value)
        raise 'The provided "page_orientation" is not valid. Try using PadesPageOrientation constants'
      end
      @page_orientation = value
    end

    def to_model
      custom_paper_size = nil
      if @paper_size == PadesPaperSize::CUSTOM
        if @custom_paper_size
          custom_paper_size = @custom_paper_size&.to_model
        else
          raise 'paper_size is set to :custom but no custom_paper_size was set'
        end
      end

      {
          'pageSize': @paper_size,
          'customPageSize': custom_paper_size,
          'pageOrientation': @page_orientation,
      }
    end
  end
end