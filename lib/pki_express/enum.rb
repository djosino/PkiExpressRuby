module PkiExpress
  class Enum
    VALUES = []

    def self.contains?(value)
      VALUES.include? (value)
    end
  end
end
