module PkiExpress
  class PadesPageOptimization
    attr_accessor :paper_size, :page_orientation
    attr_reader :custom_paper_size

    def initialize(paper_size=nil, custom_paper_size=nil)
      @page_orientation = :auto
      if custom_paper_size
        @paper_size = :custom
        @custom_paper_size = custom_paper_size
      else
        @paper_size = paper_size
      end
    end

    def custom_paper_size=(value)
      @custom_paper_size = value
      @paper_size = :custom
    end

    def to_model
      page_size = nil
      case @paper_size
      when :custom
        paper_size = 'Custom'
      when :a0
        paper_size = 'A0'
      when :a1
        paper_size = 'A1'
      when :a2
        paper_size = 'A2'
      when :a3
        paper_size = 'A3'
      when :a4
        paper_size = 'A4'
      when :a5
        paper_size = 'A5'
      when :a6
        paper_size = 'A6'
      when :a7
        paper_size = 'A7'
      when :a8
        paper_size = 'A8'
      when :letter
        paper_size = 'Letter'
      when :legal
        paper_size = 'Legal'
      when :ledger
        paper_size = 'Ledger'
      else
        raise 'The provided "pades_page_optimization" value is not valid'
      end

      custom_paper_size = nil
      if @paper_size == :custom
        if @custom_paper_size
          custom_paper_size = @custom_paper_size&.to_model
        else
          raise 'paper_size is set to :custom but no custom_paper_size was set'
        end
      end

      page_orientation = nil
      if @page_orientation
        case @page_orientation
        when :auto
          page_orientation = 'Auto'
        when :portrait
          page_orientation = 'Portrait'
        when :landscape
          page_orientation = 'Landscape'
        else
          raise 'The provided "page_orientation" value is not valid'
        end
      end
      {
          'pageSize': @paper_size,
          'customPageSize': @custom_paper_size,
          'pageOrientation': @page_orientation,
      }
    end
  end
end