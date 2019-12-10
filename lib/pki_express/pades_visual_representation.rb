module PkiExpress
  class PadesVisualRepresentation
    attr_accessor :text, :image, :position

    def initialize(text=nil, image=nil, position=nil)
      @text = text
      @image = image
      @position = position
    end

    def to_model
      unless @position
        raise new 'The visual representation position was not set'
      end
      {
          position: @position&.to_model,
          text: @text&.to_model,
          image: @image&.to_model,
      }
    end
  end
end
