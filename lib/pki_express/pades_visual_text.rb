module PkiExpress
  class PadesVisualText
    attr_accessor :horizontal_align, :text, :include_signing_time, :font_size,
                  :container, :signing_time_format

    def initialize(text=nil, include_signing_time=nil, font_size=nil)
      @horizontal_align = :left
      @text = text
      @include_signing_time = include_signing_time
      @font_size = font_size
      @container = nil
      @signing_time_format = nil
    end

    def to_model
      model = {
          'fontSize': @font_size,
          'text': @text,
          'includeSigningTime': @include_signing_time,
          'signingTimeFormat': @signing_time_format,
          'container': @container&.to_model
      }
      if @horizontal_align
        case @horizontal_align
        when :left
          model['horizontalAlign'] = 'Left'
        when :right
          model['horizontalAlign'] = 'Right'
        else
          raise 'The provided "horizontal_align" value is not valid'
        end
      end
      model
    end
  end
end
