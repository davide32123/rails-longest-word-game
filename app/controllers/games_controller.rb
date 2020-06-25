require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << Array('A'..'Z').sample }
  end

  def score
    @elapsed_time = Time.now - Time.parse(params[:start_time])
    @answer = params[:word]
    @letters = params[:letters]
    @valid_word = in_grid?(@answer, @letters)
    @real_word = nil
    @real_word = in_dictionary?(@answer) if @valid_word
  end

  def in_grid?(word, grid)
    # check if letter of word are included in the grid
    # delete return nil if item not found in array
    test_grid = grid.chars.map { |w| w.downcase }
    word.each_char do |c|
      c_index = test_grid.index(c)
      return false if c_index.nil?

      test_grid.delete_at(c_index)
    end
    true
  end

  def in_dictionary?(word)
    # check if word exists by calling API
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = open(url).read
    result = JSON.parse(result_serialized)
    result["length"] || result["found"]
  end
end
