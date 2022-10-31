# fronze_string_literal: true

# Class that assigns a player a name and color
class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
