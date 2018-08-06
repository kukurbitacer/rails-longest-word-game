require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
   alphabet = ("A".."Z").to_a
   @array_of_letters =[]
   10.times do
   @array_of_letters << alphabet.sample
   end
  end

  def score
    if session[:total_score] == nil
      session[:total_score] = 0
    end
    @letters_array = params[:array].split
    @word = params[:word]
    if check_array(@word, @letters_array) == false
      @result = "Sorry but #{@word.capitalize} can't be build out of #{params[:array]}"
    elsif check_word(@word) == false
      @result = "Sorry but #{@word.capitalize} is not a valid english word"
    else
      @result = "<strong>Congratulations!</strong> #{@word.capitalize} is a valid english word".html_safe
      @score = @word.length * @word.length
      session[:total_score] += @score
    end
  end
end

def check_word (word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  dictionary_check = open(url).read
  check = JSON.parse(dictionary_check)
  return check_value = check["found"]
end

def check_array(word, array)
  letter_array = word.upcase.split("")
  check = true
  letter_array.each do |letter|
    if array.include?(letter) == true
      array.delete_at(array.index(letter))
    else
      check = false
    end
  end
  return check
end


