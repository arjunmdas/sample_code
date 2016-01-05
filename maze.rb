gem "minitest"
require 'minitest/autorun'

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
# Maze 2 should SUCCEED

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
# Maze 3 should FAIL

class Maze
  def initialize(str)
    @arr = Array.new    
    @a_x = 0
    @a_y = 0
    @b_x = 0
    @b_y = 0

    @x_max = 0
    @y_max = 0

    str.split("\n").each do |row| 
      temp = Array.new     
      row.split("").each do |col| 
        if "#" == col
          temp.push(1)
        elsif " " == col
          temp.push(0)
        elsif "A" == col
          @a_x = @x_max
          @a_y = @y_max          
          temp.push(0)
        elsif "B" == col
          @b_x = @x_max
          @b_y = @y_max
          temp.push(0)
        end
        @x_max+=1
      end
      @y_max+=1
      @x_max=0
      @arr.push(temp)   
    end
  end

  def solvable?(x = @a_x ,y = @a_y,a = -1 ,b = -1)
    
    if a !=- 1 && b != -1
      @arr[b][a] = 1
    end 

    if x == @b_x && y == @b_y
      return true
    elsif @arr[y][x] == 1
      return false
    elsif solvable?(x,y-1,x,y)
      return true
    elsif solvable?(x+1,y,x,y)
      return true
    elsif solvable?(x,y+1,x,y)
      return true
    elsif solvable?(x-1,y,x,y)
      return true
    else
      return false
    end
  end    


  def steps
    10
  end
end

class MazeTest < Minitest::Test

  def test_good_mazes
    assert_equal true, Maze.new(MAZE1).solvable?
    assert_equal true, Maze.new(MAZE2).solvable?
  end 

  def test_bad_mazes
    assert_equal false, Maze.new(MAZE3).solvable?
  end
=begin
  def test_maze_steps
    assert_equal 44, Maze.new(MAZE1).steps
    assert_equal 75, Maze.new(MAZE2).steps
    assert_equal 0, Maze.new(MAZE3).steps
  end
=end
end

