require 'json'
require 'set'

# Salvando um objeto em JSON
class HangMan
  # attr_accessor
  
  def initialize()
    @tried_words = []
    @dictionary = load_dic('dictionary.txt')
    @current_word = @dictionary.sample
    @max_trials = 10

  end

  def to_json(*args)
    {
      current_word: @current_word,
      tried_words: @tried_words,
      max_trials: @max_trials
    }.to_json
  end

  def save_file
    File.write('saved_file.json', self.to_json)
  end

  def load_file
    json_data = File.read('saved_file.json')
    dados = JSON.parse(json_data)
    @current_word = dados["current_word"]
    @tried_words = dados["tried_words"]
    @max_trials = dados["max_trials"]
  end

  def to_s 
    puts "current_words: #{@current_words}"
    puts "idade: #{@tried_words}"
  end

  def load_dic(dic_file)
    dic_array = []
    File.open(dic_file, 'r') do |f|
      while !f.eof?
        word = f.readline.chomp
        if word.length > 5 && word.length < 12
          dic_array.push word
        end
      end
    end
    dic_array
  end

  def display
    puts "Letras tentadas: #{@tried_words}"
    puts "Tentativas restantes: #{@max_trials}"
    display_word
  end

  def display_word
    @current_word.chars.each do |word|
      if @tried_words.include?(word)
        print word
      else
        print "_"
      end
    end
    puts ""
  end

  def get_try
    puts "nova tentativa: ('save' for save)"
    tentativa = gets.chomp
    process_try(tentativa)
  end

  def process_try(tentativa)
    if tentativa == 'save'
      save_file
    end
    unless @tried_words.include?(tentativa)
      @tried_words.push(tentativa)
      unless @current_word.chars.include?(tentativa)
        @max_trials -= 1
      end
    end
  end

  def victory?
    @tried_words.to_set >= @current_word.chars.to_set
  end

  def main
    if File.exist?('saved_file.json')
      puts 'Deseja dar load no save game? y for yes'
      answer = gets.chomp
      if answer == 'y'
        load_file
      end
    end
    while (@max_trials > 0 && !victory?)
      display
      get_try
    end
    mensage = victory? ? 'Você ganhou!' : ' Você Perdeu!'
    puts "#{mensage} A resposta é #{@current_word}"
  end
end

board = HangMan.new
board.main


