module PkiExpress
  class PadesSize
    attr_accessor :width, :height

    def initialize(width, height)
      @width = width
      @height = height
    end

    def to_model
      {
          width: @width,
          height: @height,
      }
    end
  end
end
