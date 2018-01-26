# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Item
  KEYS = [:game, :food, :medicine]
  SPRITES = {
    :game => Gosu::Image.new(Util.media_path('cd_sprite.png')),
    :food => Gosu::Image.new(Util.media_path('food_sprite.png')),
    :medicine => Gosu::Image.new(Util.media_path('med_sprite.png')),
  }
  PRICES = {
    :game => [15, 35, 55, 80],
    :food => [5, 15, 30, 40],
    :medicine => [40, 80, 150]
  }
  VALUE = {
    :game => {:Health => 0, :Fun => 30},
    :food => {:Health => 20, :Fun => 10},
    :medicine => {:Health => 30, :Fun => 0}
  }
  
  attr_reader :price, :type
  def initialize(x, y)
    @time_onscreen = rand(3..5)
    @x, @y = x, y
    @type = KEYS.sample
    @image = SPRITES[@type]
    @price = PRICES[@type].sample
    @text = Gosu::Image.from_text(@price, 15)
  end
  def update
  end
  def draw
    @image.draw(
      @x,
      @y,
      1
    )
    @text.draw(
      @x + @image.width / 2 - @text.width / 2,
      @y + @image.height,
      1
    )
  end
  def done?
    now = Gosu.milliseconds
    @birth ||= now
    if(now - @birth > @time_onscreen*1000)
      return true
    end
    return false
  end
  def collides_with?(object)
    collides = false
    if(@x < object.x + object.width &&
          @x + @image.width > object.x &&
          @y < object.y + object.height &&
          @y + @image.height > object.y)
      collides = true
    end
    return collides
  end
end
