# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Intermision
  MESSAGES = {
    :Clear => 'You somehow made it',
    :Fun => {
      :High => "You're slacking off",
      :Low => "Your life becomes dull"
    },
    :Health => {
      :Low => "Your health worsens",
      #      :High => ""
    },
    :Happiness => "You're unhappy",
    :GameOver => "Are humans exceptional? Have they developed beyond their evolved state? Your death might provide a better insight"
  }
  TIME_BEFORE_INPUT = 3000
  
  attr_reader :speed_modifier
  def initialize(window)
    @window = window
    @speed_modifier = speed_factor
    @money_factor = money_factor
    @happy_modifier = happiness_factor
    @messages = get_messages
    @onscreen_time = TIME_BEFORE_INPUT
    game_over?
    reset_game_state
  end
  def update
    now = Gosu.milliseconds
    @time ||= now
    if(now - @time > @onscreen_time)
      @done = true
    end
  end
  def reset_game_state
    $game[:Happiness] += @happy_modifier
    d = $game[:Money] - $game[:Expenses]
    if (d <= 0)
      $game[:Debt] -= d
      $game[:Money] = (300*@money_factor).floor
    else
      d = d - $game[:Debt]
      if (d < 0)
        $game[:Debt] = d.abs
        $game[:Money] = (300*@money_factor).floor
      else
        $game[:Debt] = 0
        $game[:Money] = d + (300*@money_factor).floor
      end
    end
    $game[:Stage] += 1
    $game[:Health] = 0
    $game[:Fun] = 0
    $game[:Expenses] = 0
  end
  def money_factor
    mf = 1
    mf = mf * 0.5 if $game[:Health] < 100
    mf = mf * 0.75 if $game[:Fun] > 100
    return mf
  end
  def happiness_factor
    h = -1 if $game[:Fun] < 70
    h = 0 if $game[:Fun] >= 70
    h = 1 if $game[:Fun] >= 90 && $game[:Happiness] < 3
    return h
  end
  def speed_factor
    s = 1
    s = s * 0.5 if $game[:Health] < 100    
    s = s * 0.7 if $game[:Happiness] == 2
    s = s * 0.5 if $game[:Happiness] == 1
    return s
  end
  def get_messages
    @messages = []
        
    if ($game[:Fun] > 100)
      @messages.push(Gosu::Image.from_text(MESSAGES[:Fun][:High], 20, {:width => 200, :align => :center}))
      $game[:Times_Slacked] += 1
    elsif ($game[:Fun] < 70)
      @messages.push(Gosu::Image.from_text(MESSAGES[:Fun][:Low], 20, {:width => 200, :align => :center}))
    end
    
    if ($game[:Health] < 100)
      @messages.push(Gosu::Image.from_text(MESSAGES[:Health][:Low], 20, {:width => 200, :align => :center}))
      $game[:Times_Sickness] += 1
    end
    
    if ($game[:Happiness] < 3)
      @messages.push(Gosu::Image.from_text(MESSAGES[:Happiness], 20, {:width => 200, :align => :center}))
    end
    
    @messages.push(Gosu::Image.from_text(MESSAGES[:Clear], 20, {:width => 200, :align => :center})) if @messages.empty?
    return @messages
  end
  def done?
    @done ||= false
    return @done
  end
  def game_over?
    if ($game[:Happiness] == 0 || $game[:Debt] >= 1000 || $game[:Times_Slacked] > 5 || $game[:Times_Sickness] > 5)
      @messages = []
      @messages.push(Gosu::Image.from_text(MESSAGES[:GameOver], 30, {:width => 700, :align => :center}))
      @messages.push(Gosu::Image.from_text("You survived #{$game[:Stage]} rounds", 20, {:width => 200, :align => :center}))
      $game[:Stage] = 1
      @onscreen_time = 6000
      return @messages
    end
  end
  def draw
    sep = 20
    pos = 0
    @messages.map do |message| 
      message.draw(@window.width/2 - message.width/2, pos + sep, 1)
      pos += message.height
    end
  end
end