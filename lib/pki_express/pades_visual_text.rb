module PkiExpress
  class PadesVisualText
    attr_reader :horizontal_align
    attr_accessor :text, :include_signing_time, :font_size,
                  :container, :signing_time_format

    def initialize(text=nil, include_signing_time=nil, font_size=nil)
      @horizontal_align = :left
      @text = text
      @include_signing_time = include_signing_time
      @font_size = font_size
      @container = nil
      @signing_time_format = nil
    end

    def horizontal_align=(value)
      unless PadesTextHorizontalAlign.contains?(value)
        raise 'The provided "horizontal_align" is not valid. Try using PadesTextHorizontalAlign constants'
      end

      @horizontal_align = value
    end

    def to_model
      {
          'fontSize': @font_size,
          'text': @text,
          'includeSigningTime': @include_signing_time,
          'signingTimeFormat': @signing_time_format,
          'container': @container&.to_model,
          'horizontalAlign': @horizontal_align
      }
    end
  end
end
