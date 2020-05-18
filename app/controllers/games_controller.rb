require 'date'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET_ARRAY = ('A'..'Z').to_a
  def new
    @letters = Array.new(rand(5..10) { |_| ' ' }).map! { ALPHABET_ARRAY.sample }
    @time_start = Time.now.to_f
  end

  def score
    # calculate the time needed
    puts '--- '
    puts Time.now.to_f
    puts params[:time_start].to_f
    @time_needed = Time.now.to_f - params[:time_start].to_f

    # parse from API
    attempt_hash = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read)

    if params[:word].upcase.chars.all? { |c| params[:word].upcase.count(c) <= params[:letters_array].count(c) } == false
      @score = 0
      @message = "The word '#{params[:word]}' can not be formed with the letters #{params[:letters_array]}"
    elsif attempt_hash['found'] == false
      @score = 0
      @message = "Sorry, '#{params[:word]}' is not a valid English word. Try again!"
    else
      @score = params[:word].length.to_f / @time_needed
      @message = "Congratulations! '#{params[:word]}' is a valid English word!"
    end
  end
end
