require 'nbayes'
require 'byebug'

# Criar um classificador
nbayes = NBayes::Base.new
# Treinar o classificador com exemplos - as palavras da String são divididas em um array
nbayes.train( "Nice article that my father, who grew up in Beijing during the teens through 30's, would have enjoyed.".split(/\s+/), 'GOOD' )
nbayes.train( "Wonderful article, perfectly true to Beijing which is a city I am ever so fond of.".split(/\s+/), 'GOOD' )
nbayes.train( "Wonderful city and people".split(/\s+/), 'GOOD' )
nbayes.train( "Thank you for bringing back memories of Ritan Park.".split(/\s+/), 'GOOD' )
nbayes.train( "What a lovely article. I too love Beijing and especially The Temple of the Sun.".split(/\s+/), 'GOOD' )
nbayes.train( "Thats a bad city".split(/\s+/), 'BAD' )
nbayes.train( "i hate this city".split(/\s+/), 'BAD' )
nbayes.train( "this city is a trash".split(/\s+/), 'BAD' )
nbayes.train( "bad city with bad people but wonderful food".split(/\s+/), 'BAD' )

def main
  @nbayes = NBayes::Base.new

  impo_train_negative
  impo_train_positive


  tokens = "this movie is exeptional".split(/\s+/)

  result = @nbayes.classify(tokens)


  # Imprime a probabilidade da mensagem ser SPAM
  p result['GOOD']
  # Imprime a probabilidade da mensagem ser HAM
  p result['BAD']


  # Imprime a classe em que o texto foi classificado. (SPAM ou HAM)
  p result.max_class
end



def impo_train_positive
  entries = Dir.entries('/mnt/c/aclImdb/train/pos') 
  
  100.times do |index|
    entry = entries[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data(entry, 'pos')
    train_positive(comment)
  end
end

def train_positive(comment)
  #nbayes = NBayes::Base.new
  @nbayes.train(comment.split(/\s+/), 'GOOD')
end

def impo_train_negative
  entries = Dir.entries('/mnt/c/aclImdb/train/neg') 
  
  100.times do |index|
    entry = entries[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data(entry, 'neg')
    train_negative(comment)
  end
  # entries.each do |entry|
  #   next if ['.', '..'].include?(entry)
  #   puts get_file_data(entry)
  # end

end

def get_file_data(file_name, type)
  file = File.open("/mnt/c/aclImdb/train/#{type}/#{file_name}", "r")
  data = file.read
  file.close
  return data
end

def train_negative(comment)
  #nbayes = NBayes::Base.new
  @nbayes.train(comment.split(/\s+/), 'BAD')
end

main

# Dividir mensagem que precisa ser classificada
#tokens = "Now is the time to buy Viagra cheaply and discreetly".split(/\s+/)
# tokens = "Good city".split(/\s+/)
# result = nbayes.classify(tokens)
# # Imprime a classe em que o texto foi classificado. (SPAM ou HAM)
# p result.max_class
# # Imprime a probabilidade da mensagem ser SPAM
# p result['SPAM']
# # Imprime a probabilidade da mensagem ser HAM
# p result['HAM']