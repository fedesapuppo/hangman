# :nodoc:

class Game
  attr_accessor :secret_word, :currently_guessed, :guesses_left

  def initialize
    @secret_word = generate_secret_word.upcase!
    @currently_guessed = ''
    @secret_word.length.times { @currently_guessed << '_' }
    @guesses_left = 10
  end

  def generate_secret_word
    dictionary = File.open('../words.txt', 'r')
    words = []
    dictionary.each_line do |l|
      l.chomp!
      words << l if l.length <= 12 && l.length >= 5
    end
    dictionary.close
    words.sample
  end

  def display_welcome_message
    puts 'Welcome to Hangman!!. Can you guess the secret word?'
  end

  def make_guess
    puts "Please, enter a letter, or enter 'save' to save the game"
    guess = gets.chomp.upcase
    if guess == 'SAVE'
      game_state = YAML.dump($game)
      File.open(File.join(Dir.pwd, "../saved/saved_game.yaml"), 'w') { |file| file.write game_state}
      puts 'The game has been saved'
      puts
    end
    until ((/[A-Z]/.match(guess) && guess.length == 1) || (guess == 'SAVE'))
      puts "Invalid choice. Please, enter a single letter, or 'save' to save the game:"
      guess = gets.chomp.upcase
    end
    guess
  end

  def initialize_game
    game = Game.new
    display_welcome_message
    puts "You have #{@guesses_left} guesses left"
    puts @currently_guessed
  end

  def check_guess(guess)
    if @secret_word.include? guess
      add_guess(guess)
    elsif guess != 'SAVE'
      @guesses_left -= 1
    end
  end

  def add_guess(guess)
    @secret_word.split('').each_with_index do |letter, index|
      @currently_guessed[index] = letter if letter == guess
    end
  end

  def check_win_and_lose
    if @guesses_left.zero?
      puts 'You have no guesses left.. you lost the game!!'
    elsif @currently_guessed == @secret_word
      puts 'Well done! You guessed the secret word and won the game!!'
    end
  end

  def play_new_game
    initialize_game
    while @guesses_left.positive? && @currently_guessed != @secret_word
      guess = make_guess
      check_guess(guess)
      puts "You have #{@guesses_left} guesses left"
      puts @currently_guessed
      check_win_and_lose
    end
  end

  def play_loaded_game
    while @guesses_left.positive? && @currently_guessed != @secret_word
      guess = make_guess
      check_guess(guess)
      puts "You have #{@guesses_left} guesses left"
      puts @currently_guessed
      check_win_and_lose
    end
  end
end
