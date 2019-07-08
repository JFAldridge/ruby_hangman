require_relative "game_core.rb"

class StartsGame
  def initialize
    introduction
    create_or_load
  end

  def introduction
    puts "  A random hidden word will be chosen. You must 
  figure out the word by guessing it's letters. 
  You have a set number of guesses.  If you don't 
  guess the word in time, a man will die, so stay 
  sharp.  If a any point you'd like to save a game 
  and come back to it, type 'save' instead of your 
  letter guess.  I will be here waiting when you 
  return"
  end

  def create_or_load
    puts "Would you like to \n (1) create a new game or \n (2) resume a saved one?"
    choice = 0
    until choice == "1" || choice == "2"
      puts "Please input 1 or 2"
      choice = gets.chomp.strip
    end
    Game.new if choice == "1"
    if choice == "2"
      any_saves = true
      any_saves = pic_from_saved_game
      unless any_saves
        puts "There are no saves on file.  Let's start a new game. :)"
        Game.new
      end
    end
    play_again
  end

  def pic_from_saved_game
    paths = Dir.glob("../saves/*.yml").sort_by { |x| File.mtime(x) }
    return false if paths.length == 0
    puts "Saves:"
    display_presentable_save_data(paths)
    
    choice = -1
    while choice < 1 || choice > paths.length
      puts "Choose your save by it's number."
      choice = gets.chomp.strip.to_i
    end
    load_then_delete_save(paths[choice - 1])
  end

  def display_presentable_save_data(paths)
    guesses_and_timestamps = paths.map { |path| File.basename(path, ".*").split("-") }
    
    longest_path = guesses_and_timestamps.max_by {|arr| arr[0].length}[0].length
    
    guesses_and_timestamps.each_with_index do |g_and_t, i|
      guessed_word = g_and_t[0]
      day_hour_minute = g_and_t[1].split("_")
      
      puts "(#{i + 1}) Game progress: #{guessed_word.split("").join(" ").ljust(longest_path.to_i * 2)}  Time of save: #{day_hour_minute[0]}  #{day_hour_minute[1]}:#{day_hour_minute[2]}"
    end
  end

  def load_then_delete_save(path)
    saved_game = YAML::load(File.read(path))
    delete_save(path)
    saved_game.play_game
  end

  def delete_save(path)
    File.delete(path)
  end

  def play_again
    puts "Would you like to play again?"
    again = ""
    until again == "yes" || again == "no"
      puts 'Enter "yes" or "no".'
      again = gets.chomp.strip.downcase
    end
    if again == "yes"
      create_or_load
    else 
      puts "See you later!"
    end
  end
end

new_game = StartsGame.new
