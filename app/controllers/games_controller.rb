require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    # Is the route when landing AND when clicking in the button
    # Define the letters that will be sorted
    @letters = []
    @start_time = Time.now
    # Get a sample of them
    10.times { @letters << ('A'..'Z').to_a.sample.first }
  end

  def score
    # Gets the input from the form
    letters = params[:sampled_letters].split
    word = params[:word]
    response_time = Time.now - params[:start_time].to_datetime
    # Uses it to get the final score
    @final_score = (
            # Show to the user
            if word.split('').all? { |letter| letters.include?(letter.upcase) && word.split('').count(letter) <= letters.count(letter.upcase) }
              if valid_word?(word)
                "Your score is #{calculate_score(word, letters, response_time)}"
              else
                "#{word} isn't an English valid word!"
              end
            else
              "You can't form the word #{word} from #{letters.join(', ')}."
            end)
  end

  private

  def valid_word?(word)
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read, symbolize_names: true)[:found]
  end

  def calculate_score(word, letters, response_time)
    response_time_penalty = response_time < 10 ? response_time : response_time * 2
    word_size_penalty = word.size >= 5 ? 0 : (letters.size - word.size) * 2
    score = 100 - word_size_penalty - response_time_penalty

    (score >= 0 ? score : 0).to_i
  end
end
