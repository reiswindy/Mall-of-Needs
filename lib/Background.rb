# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Background
  MOVE_DELAY = 25 #ms
  TIME_ONSCREEN = 4000 #ms
  SPRITES = [
    Gosu::Image.new(Util.media_path('background.jpg')),
    Gosu::Image.new(Util.media_path('background_fun.png')),
    Gosu::Image.new(Util.media_path('mallsoft.jpg'))
  ]
  DIRECTIONS = [
    :UP, :DOWN, :RIGHT, :LEFT
  ]

  def initialize(x, y)
    @sprite = SPRITES.sample
    @direction = DIRECTIONS.sample
    @x, @y = x, y
  end
  
  def update    
    if(needs_movement)
#      puts "Moved"
      case @direction
      when :UP
        @y -= 1
#        break
      when :DOWN
        @y += 1
#        break
      when :RIGHT
        @x += 1
#        break
      when :LEFT
        @x -= 1
#        break
      end
    end
  end
  
  def draw
    @sprite.draw( 
      @x - @sprite.width / 2.0 , 
      @y - @sprite.height / 2.0, 
      0,
      1,
      1,
      Gosu::Color.new(get_alpha, 255, 255, 255))
  end
  
  def needs_movement
    now = Gosu.milliseconds
    @last_movement ||= now
#    puts "Time move: #{@last_movement}"
#    puts "Now: #{now}"
    if (now - @last_movement) > MOVE_DELAY
      @last_movement = now
#      puts "Done move"
      return true
    end
    return false
  end
  
  def get_alpha
    alpha_factor = (Gosu.milliseconds % TIME_ONSCREEN).to_f / TIME_ONSCREEN
    alpha = (255 * (1 - alpha_factor)).floor
    return alpha
  end
  
  def done?
    return true if get_alpha == 0 
    return false
  end
  
  def reset(x, y)
    @sprite = SPRITES.sample
    @direction = DIRECTIONS.sample
    @x, @y = x, y
  end
end
