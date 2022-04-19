# frozen_string_literal: true
require 'yaml'
require_relative 'game'

puts 'Welcome to Hangman! Would you like to play a new game, or load a saved game?'
puts '1) Play a new game'
puts '2) Load game'
answer = gets.chomp
if answer == '1'
    $game = Game.new
    $game.play_new_game
else 
    game_state = File.open(File.join(Dir.pwd, "../saved/saved_game.yaml"), 'r')
    $game = YAML.load(game_state)
    $game.play_loaded_game
end
