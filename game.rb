require 'gosu'
 
 MAZE1 = %{#####################################
# #   #     #A        #     #       #
# # # # # # ####### # ### # ####### #
# # #   # #         #     # #       #
# ##### # ################# # #######
#     # #       #   #     # #   #   #
##### ##### ### ### # ### # # # # # #
#   #     #   # #   #  B# # # #   # #
# # ##### ##### # # ### # # ####### #
# #     # #   # # #   # # # #       #
# ### ### # # # # ##### # # # ##### #
#   #       #   #       #     #     #
#####################################}
# Maze 1 should SUCCEED

MAZE2 = %{#####################################
# #       #             #     #     #
# ### ### # ########### ### # ##### #
# #   # #   #   #   #   #   #       #
# # ###A##### # # # # ### ###########
#   #   #     #   # # #   #         #
####### # ### ####### # ### ####### #
#       # #   #       # #       #   #
# ####### # # # ####### # ##### # # #
#       # # # #   #       #   # # # #
# ##### # # ##### ######### # ### # #
#     #   #                 #     #B#
#####################################}

MAZE3 = %{#####################################
# #   #           #                 #
# ### # ####### # # # ############# #
#   #   #     # #   # #     #     # #
### ##### ### ####### # ##### ### # #
# #       # #  A  #   #       #   # #
# ######### ##### # ####### ### ### #
#               ###       # # # #   #
# ### ### ####### ####### # # # # ###
# # # #   #     #B#   #   # # #   # #
# # # ##### ### # # # # ### # ##### #
#   #         #     #   #           #
#####################################}

X_OFFSET = 50
Y_OFFSET = 200

  class Starship
    
    attr_accessor :x
    attr_accessor :y
    attr_accessor :size
      attr_reader :front

    def initialize(size)
      @image = Gosu::Image.new("media/starfighter.bmp")
      @x = 0
      @y = 0
      @x_temp = 0
      @y_temp = 0
      @angle = 0
      @size = size
      @front = "-y"  
      @update_count=0    
    end

    def reverse
      @angle+=180
      if @front == "x"
        @front = "-x"
      elsif @front == "y"
        @front = "-y"
      elsif @front == "-x"
        @front = "x"
      else
        @front = "y"
      end
    end

    def turn_left
      @angle-=90
      if @front == "x"
        @front = "-y"
        @y -= 1
      elsif @front == "y"
        @front = "x"
        @x += 1
      elsif @front == "-x"
        @front = "y"
        @y += 1
      else
        @front = "-x"
        @x -= 1
      end
    end

    def turn_right
      @angle+=90
      if @front == "x"
        @front = "y"
        @y += 1
      elsif @front == "y"
        @front = "-x"
        @x -= 1
      elsif @front == "-x"
        @front = "-y"
        @y -= 1
      else
        @front = "x"
        @x += 1
      end
    end

    def go_forward
      if @update_count == 10
        if @front == "x"
          @x += 1
        elsif @front == "y"
          @y += 1
        elsif @front == "-x"
          @x -= 1
        else
          @y -= 1
        end
        @update_count = 0
        @x_temp=0
        @y_temp=0
      else
        if @front == "x"
          @x_temp += 0.1 
        elsif @front == "y"
          @y_temp += 0.1
        elsif @front == "-x"
          @x_temp -= 0.1
        else
          @y_temp -= 0.1
        end
        @update_count+=1
      end
    end

    def draw
      x = (@x + @x_temp)*@size + X_OFFSET + @size/2 
      y = (@y + @y_temp)*@size + Y_OFFSET + @size/2 
      @image.draw_rot(x,y,1,@angle,0.5,0.5,0.5,0.5,Gosu::Color::WHITE);
    end
  end

  class GameWindow < Gosu::Window
    def initialize(width=1280, height=800, fullscreen=false)
      super 
      self.caption = 'Maze'

      #colors 
      @bgcolor = Gosu::Color::BLACK#0xB76EB8FF #Gosu::Color::GRAY
      @color_brick = Gosu::Color::BLACK#0xB76EB8FF#Gosu::Color::RED
      @color_empty = Gosu::Color::GRAY
      @color_A = Gosu::Color::RED
      @color_B = Gosu::Color::RED

      #maze
      @str = MAZE1
      @rows = @str.split("\n")
      @draw_first_time = true      
      @block_size = 30
      @bx_pos = 0
      @by_pos = 0
      @starship = Starship.new(@block_size)
      @start = false
      @bgm=Gosu::Song.new("media/bgm.mp3")
    end

    def update
      if Gosu::button_down? Gosu::KbS
        @start = true
        @bgm.play
      end

      if Gosu::button_down? Gosu::KbQ
        @str = MAZE1
        init
      elsif Gosu::button_down? Gosu::KbW
        @str = MAZE2
        init
      elsif Gosu::button_down? Gosu::KbE     
        @str = MAZE3
        init
      end

      if (@starship.x != @bx_pos || @starship.y != @by_pos) && @start == true
        if @starship.front == "x" 
          if @rows[@starship.y+1].split("")[@starship.x] != "#"
            @starship.turn_right
          elsif @rows[@starship.y].split("")[@starship.x+1] != "#"
            @starship.go_forward            
          elsif @rows[@starship.y-1].split("")[@starship.x] != "#"
            @starship.turn_left
          else
            @starship.reverse
          end
        elsif @starship.front == "-y" 
          if @rows[@starship.y].split("")[@starship.x+1] != "#"
            @starship.turn_right
          elsif @rows[@starship.y-1].split("")[@starship.x] != "#"
            @starship.go_forward
          elsif @rows[@starship.y].split("")[@starship.x-1] != "#"
            @starship.turn_left
          else
            @starship.reverse
          end
        elsif @starship.front == "-x"         
          if @rows[@starship.y-1].split("")[@starship.x] != "#"
            @starship.turn_right 
          elsif @rows[@starship.y].split("")[@starship.x-1] != "#"
            @starship.go_forward           
          elsif @rows[@starship.y+1].split("")[@starship.x] != "#"
            @starship.turn_left
          else
            @starship.reverse
          end
        elsif @starship.front == "y" 
          if @rows[@starship.y].split("")[@starship.x-1] != "#"
            @starship.turn_right 
          elsif @rows[@starship.y+1].split("")[@starship.x] != "#"
            @starship.go_forward           
          elsif @rows[@starship.y].split("")[@starship.x+1] != "#"
            @starship.turn_left
          else
            @starship.reverse
          end
        end
      elsif(true == @start)
        @starship.x = @bx_pos
        @starship.y = @by_pos  
        @bgm.stop
      end
    end  
   
    def draw
      x = 0
      y = 0  
      @rows.each do |row|
        row.split("").each do |blockade|
          if blockade == '#'
            draw_block(x,y)
          elsif blockade == 'A' 
            if @draw_first_time == true
              draw_empty(x,y)
              @starship.x = x
              @starship.y = y
              @starship.draw
              @draw_first_time = false
            else
              draw_empty(x,y)
              @starship.draw
            end 
          elsif blockade == 'B'
            draw_empty(x,y)
            draw_target(x,y)
            @bx_pos = x
            @by_pos = y
          else  
            draw_empty(x,y)
          end
          x += 1
        end
        x  = 0
        y += 1
      end
    end

    private 

    def init
      @rows = @str.split("\n")
      @bx_pos = 0
      @by_pos = 0
      @start = false
      @draw_first_time = true
      @bgm.stop
    end

    def draw_block(x,y)
      x = x*@block_size + X_OFFSET
      y = y*@block_size + Y_OFFSET
      draw_quad(x, y, @color_brick, x+@block_size, y, @color_brick, x, y+@block_size, @color_brick, x+@block_size, y+@block_size, @color_brick, -1)
    end

    def draw_empty(x,y)
      x = x*@block_size + X_OFFSET
      y = y*@block_size + Y_OFFSET
      draw_quad(x, y, @color_empty, x+@block_size, y, @color_empty, x, y+@block_size, @color_empty, x+@block_size, y+@block_size, @color_empty, -1)
    end

    def draw_target(x,y)
      x = x*@block_size + X_OFFSET
      y = y*@block_size + Y_OFFSET
      draw_triangle(x, y+@block_size,  @color_B, x+@block_size, y+@block_size, @color_B, x+@block_size/2, y, @color_B, -1)
    end
  end
  
 window = GameWindow.new
 window.show