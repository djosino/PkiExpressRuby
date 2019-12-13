module PkiExpress
  class PadesVisualImage
    attr_reader :horizontal_align, :vertical_align
    attr_accessor :opacity, :content, :url,
                  :mime_type

    def initialize(image_content=nil, image_url = nil, image_mime_type=nil)
      @opacity = 100
      @horizontal_align = PadesHorizontalAlign::CENTER
      @vertical_align = PadesVerticalAlign::CENTER
      @content = image_content
      @url = image_url
      @mime_type = image_mime_type
    end

    def horizontal_align=(value)
      unless PadesHorizontalAlign.contains?(value)
        raise 'The provided "horizontal_align" is not valid. Try using PadesHorizontalAlign constants'
      end

      @horizontal_align = value
    end

    def vertical_align=(value)
      unless PadesVerticalAlign.contains?(value)
        raise 'The provided "vertical_align" is not valid. Try using PadesVerticalAlign constants'
      end

      @vertical_align = value
    end

    def to_model
      resource_model = {
          'mimeType': @mime_type,
      }
      if @content
        resource_model['content'] = Base64.encode64(@content)
      elsif @url
        resource_model['url'] = @url
      else
        raise 'The image content was not set, neither its URL'
      end

      {
          resource: resource_model,
          opacity: @opacity,
          horizontal_align: @horizontal_align,
          vertical_align: @vertical_align,
      }
    end
  end
end