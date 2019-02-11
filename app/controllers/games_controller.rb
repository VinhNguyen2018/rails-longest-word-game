require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    @letters = (0...10).map { o[rand(o.length)] }
    @words = params[:word]
  end

  def score
    letters = params[:letters].upcase.split(' ')
    word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/autocomplete/#{word}"
    word_serialized = open(url).read
    wagon_dico = JSON.parse(word_serialized)
    result = word.split('')
    if result.all? { |e| letters.include?(e) } == true
      if wagon_dico["truncated_result"] == true
        @message = "Congratulations! #{word.upcase} is a valid English word !"
      else
        @message = "#{word.upcase} is not a valid English word !"
        @message
      end
    else
      @message = "#{word.upcase} cannot be build out of #{letters.join(', ')}"
    end
    @message
  end
end
# a2.all? { |e| a1.include?(e) }
