require_relative "game_graphics.rb"
require "yaml"

class Game
  def initialize
    @letters_of_hidden_word = create_hidden_word_arr
    @letters_of_guessed_word = Array.new(@letters_of_hidden_word.length, "_")
    @letters_tried = []
    @turns_allotted = how_difficult
    @turns_remaining = @turns_allotted
    @game_status = "playing"
    play_game
  end
  attr_accessor :game_status

  def play_game
    while @game_status == "playing"
      show_board
      show_guess_count
      letter_guess
      @game_status = "won" if win_check
      @game_status = "lost" if @turns_remaining == 0
    end
    inform_of_win_loss_or_save
  end

  def show_board
    gallow_graphics(@turns_remaining)
    print @letters_of_guessed_word.join(" ")
  end
  
  def show_guess_count
    if @turns_allotted == @turns_remaining
      puts "  You have #{@turns_remaining} guesses.  Good luck!"
    else
      puts "  You have #{@turns_remaining} left."
    end
  end
  
  def letter_guess
    letter = ""
    while letter == ""
      puts "Please pick a letter."
      guess = gets.chomp.downcase
      if guess == 'save'
        save_game
        @game_status = "saved" 
        break
      end
      next unless ('a'..'z').include? guess
      if @letters_tried.include? guess
        puts "You've already tried that letter. Letters guessed: #{@letters_tried.join(", ")}"
        next
      end
      letter = guess
    end
    return if @game_status == "saved"
    @letters_tried << letter
    check_letter_against_hidden_word(letter)
  end
  
  def check_letter_against_hidden_word(letter)
    letter_found = false
    @letters_of_hidden_word.each_with_index do |let, i|
      if let == letter
        @letters_of_guessed_word[i] = letter
        letter_found = true
      end
    end
    @turns_remaining -= 1 unless letter_found 
    inform_if_letter_was_found(letter_found)
  end
  
  def inform_if_letter_was_found(letter_found)
    puts letter_found ? "You found a letter!" : "Letter not found.  Try again!"
  end
  
  def win_check
    @letters_of_guessed_word.none? {|let| let == "_"} 
  end

  def inform_of_win_loss_or_save()
    puts "You won!  #{@letters_of_hidden_word.join("")}" if @game_status == "won"
    if @game_status == "lost"
      puts "The word was '#{@letters_of_hidden_word.join("")}'"
      puts "  You lost. :p"
    end
    if @game_status == "saved"
      puts "Your game has been saved."
    end
  end
  
  def create_hidden_word_arr
    dictionary = []
    File.foreach("./../5desk.txt"){ |line| dictionary << line}
  
    hidden_word = ""
    hidden_word = dictionary.sample.strip until (5..12).include?(hidden_word.length)
    hidden_word.downcase.split("")
  end
  
  def how_difficult
    print 'How difficult would you like the game?'
    3.times do
      puts '  Enter "easy", "medium", or "hard"'
      difficulty = gets.chomp.strip.downcase
      if difficulty == "easy"
        return 7
      elsif difficulty == "medium"
        return 6
      elsif difficulty == "hard"
        return 5
      end
    end
    puts "Lets start with easy."
    return 7
  end

  def save_game
    now = Time.new
    File.open("../saves/#{@letters_of_guessed_word.join("")}-#{now.day}_#{now.hour}_#{now.min}.yml", "w"){|file| file.puts YAML::dump(self)}
  end
end
  
