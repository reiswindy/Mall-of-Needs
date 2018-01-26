# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Player
  SPRITE = Util.media_path('player.png')
  SPEED = 4
  
  attr_reader :x, :y
  attr_accessor :speed_factor
  
  def initialize(window)
    @speed_factor = 1
    @image = Gosu::Image.new(SPRITE)
    @x , @y = window.width/2, window.height/2
    @window = window
  end
  def update
    @x += @speed_factor*SPEED if @window.button_down?(Gosu::KbRight)
    @x = @window.width if @x > @window.width
    @x -= @speed_factor*SPEED if @window.button_down?(Gosu::KbLeft)
    @x = 0 if @x < 0
    @y += @speed_factor*SPEED if @window.button_down?(Gosu::KbDown)
    @y = @window.height if @y > @window.height
    @y -= @speed_factor*SPEED if @window.button_down?(Gosu::KbUp)
    @y = 0 if @y < 0
  end
  def draw
    @image.draw(
      @x - @image.width / 2.0 , 
      @y - @image.height / 2.0, 
      1)
  end
  def width
    return @image.width
  end
  def height
    return @image.height
  end
end
