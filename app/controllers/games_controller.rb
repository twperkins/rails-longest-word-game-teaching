class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    counter = 0
    while counter < 9
      @letters << alphabet.sample
      counter += 1
    end

    vowels = %w[A E I O U]
    @letters << vowels.sample
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    if letter_check == false
      @result = "Sorry but #{@word} can't be built out of #{@letters.join}"
    elsif dictionary_check == false && letter_check == true
      @result = "Sorry but #{@word} isn't in the dictionary"
    elsif dictionary_check == true && letter_check == true
      @result = "Congratulations #{@word} is a valid word!"
      @score = session[:score] + @word.length
    else
      @result = 'error'
    end
  end

  private

  def dictionary_check
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    serialised = URI.open(url).read
    dictionary = JSON.parse(serialised)
    dictionary['found']
  end

  def letter_check
    @word.each_char.all? do |letter|
      @letters.map(&:downcase).include?(letter) && @letters.map(&:downcase).join.count(letter) >= @word.count(letter)
    end
  end
end
