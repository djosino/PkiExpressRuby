module PkiExpress
  class PadesVisualRectangle
    attr_accessor :left, :top, :right, :bottom, :width, :height

    def initialize
      @left = nil
      @top = nil
      @right = nil
      @bottom = nil
      @width = nil
      @height = nil
    end

    def set_width_centered(width)
      @width = width
      @left = nil
      @right = nil
    end

    def set_width_left_anchored(width, left)
      @width = width
      @left = left
      @right = nil
    end

    def set_width_right_anchored(width, right)
      @width = width
      @left = nil
      @right = right
    end

    def set_horizontal_stretch(left, right)
      @width = nil
      @left = left
      @right = right
    end

    def set_height_centered(height)
      @height = height
      @top = nil
      @bottom = nil
    end

    def set_height_top_anchored(height, top)
      @height = height
      @top = top
      @bottom = nil
    end

    def set_height_bottom_anchored(height, bottom)
      @height = height
      @top = nil
      @bottom = bottom
    end

    def set_vertical_stretch(top, bottom)
      @height = nil
      @top = top
      @bottom = bottom
    end

    def to_model
      {
          left: @left,
          top: @top,
          right: @right,
          bottom: @bottom,
          width: @width,
          height: @height,
      }
    end

  end
end
