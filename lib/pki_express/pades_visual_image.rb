module PkiExpress
  class PadesVisualImage
    attr_accessor :opacity, :horizontal_align, :vertical_align, :content, :url,
                  :mime_type

    def initialize(image_content=nil, image_url = nil, image_mime_type=nil)
      @opacity = 100
      @horizontal_align = :center
      @vertical_align = :center
      @content = image_content
      @url = image_url
      @mime_type = image_mime_type
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

      horizontal_align = nil
      if @horizontal_align
        case @horizontal_align
        when :left
          horizontal_align = 'Left'
        when :center
          horizontal_align = 'Center'
        when :right
          horizontal_align = 'Right'
        else
          raise 'Invalid horizontal align value. Available values: :left, :center, :right'
        end
      end

      vertical_align = nil
      if @vertical_align
        case @vertical_align
        when :top
          vertical_align = 'Top'
        when :center
          vertical_align = 'Center'
        when :bottom
          vertical_align = 'Bottom'
        else
          raise 'Invalid vertical align value. Available values: :top, :center, :bottom'
        end
      end
      {
          resource: resource_model,
          opacity: @opacity,
          horizontal_align: horizontal_align,
          vertical_align: vertical_align,
      }
    end
  end
end