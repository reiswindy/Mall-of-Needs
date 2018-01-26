$: << File.dirname(__FILE__)

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require "bundler/setup"
require "gosu"
require "Util"
require "Background"
require "Player"
require "Item"
require "Intermision"

$game = {
  :Health => 0, 
  :Fun => 0, 
  :Happiness => 3, 
  :Money => 300, 
  :Debt => 0, 
  :Stage => 1, 
  :Expenses => 0,
  :Times_Slacked => 0,
  :Times_Sickness => 0
}

class Game < Gosu::Window
  def initialize (width=640, height=480, fullscreen=false)
    super
    self.caption = "Mall of Needs"
    @aesthetics = []
    @items = []
    @player = Player.new(self)
    @song = Gosu::Song.new(Util.media_path('Fountain_Plaza.ogg'))
    @song.volume = 0.5
    @song.play(true)
    @kaching = Gosu::Sample.new(Util.media_path('Kaching.ogg'))
    @intermision = nil
    start_timer
    update_texts
  end
  def update
    if(!@intermision)
      if (@aesthetics.empty?) 
        @aesthetics.push(Background.new(rand(0..width), rand(0..height)))
      end
      if (@items.empty? || needs_item?)
        @items.push(Item.new(rand(0..width), rand(0..height)))
      end
      @aesthetics.map { |item| if item.done? then item.reset(rand(0..width), rand(0..height)) end }
      @aesthetics.map { |item| item.update }
      @items.reject! { |item| item.done? }
      @player.update
      if(object = player_collided?)
        @kaching.play(1, 3)
        @items.delete(object)
        $game[:Expenses] += object.price 
        $game[:Health] += Item::VALUE[object.type][:Health]
        $game[:Fun] += Item::VALUE[object.type][:Fun]
        puts $game.to_s
        update_texts
      end
      update_timer
    else
      @intermision.update
      if @intermision.done?
        @player.speed_factor = @intermision.speed_factor
        @intermision = nil
        update_texts
        start_timer
      end
    end
  end
  def draw
    if(!@intermision)
      @aesthetics.each { |item| item.draw }
      @items.each { |item| item.draw }
      @player.draw
      @time_text.draw(width/2 - @time_text.width/2, 20, 1)
      @money.draw(20, 20, 1)
      @expenses.draw(width - (20+@expenses.width), 20, 1)
      @fun.draw(20, height - 80, 1)
      @health.draw(20, height - 55, 1)
      if $game[:Stage] != 1
        @debt.draw(20, height - 30, 1)
      end
    else
      @intermision.draw
    end
  end
  def needs_item?
    if(@items.size < 5)
      if(rand(0..1000) <= 20)
        return true
      end
    end
    return false
  end
  def player_collided?
    object = false
    @items.each do |item|
      if (item.collides_with?(@player))
        object = item
        break
      end
    end
    return object
  end
  def update_texts
    @money = Gosu::Image.from_text(($game[:Stage]==1)?$game[:Money]:"Savings: $#{$game[:Money]}", 25)
    @expenses = Gosu::Image.from_text(($game[:Stage]==1)?$game[:Expenses]:"Spent: $#{$game[:Expenses]}", 25)
    @fun = Gosu::Image.from_text("Fun Needs: #{$game[:Fun]}%", 25)
    @health = Gosu::Image.from_text("Health Needs: #{$game[:Health]}%", 25)
    @debt = Gosu::Image.from_text("Debt: $#{$game[:Debt]}", 25)
  end
  def start_timer
    @time_left = 15
    @time = Gosu.milliseconds
    @time_text = Gosu::Image.from_text("Days Left: $#{@time_left}", 25)
  end
  def update_timer
    now = Gosu.milliseconds
    @time ||= now
    if(now - @time > 1000)
      @time = now
      @time_left -= 1
      @time_text = Gosu::Image.from_text("Days Left: #{@time_left}", 25)
    end
    if(@time_left < 0)
      @intermision = Intermision.new(self)
    end
  end
end

Game.new.show