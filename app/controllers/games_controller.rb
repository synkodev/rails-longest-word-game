require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    # Is the route when landing AND when clicking in the button
    # Define the letters that will be sorted
    @letters = []
    # Get a sample of them
    10.times { @letters << ('A'..'Z').to_a.sample.first }
  end

  def score
    # Gets the input from the form
    letters = params[:sampled_letters].split
    word = params[:word]
    # Uses it to get the final score
    @final_score = (
            if word.split('').all? { |letter| word.split('').count(letter) <= letters.count(letter) }
              if valid_word?(word)
                "Your score is #{calculate_score(word, letters)}"
              else
                "#{word} isn't an English valid word!"
              end
            else
              "You can't form the word #{word} from #{letters.join(', ')}."
            end)
    # Show to the user
  end

  private

  def valid_word?(word)
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read, symbolize_names: true)[:found]
  end

  def calculate_score(word, letters)
  end
end
