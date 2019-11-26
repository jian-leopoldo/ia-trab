require 'nbayes'
require 'byebug'


def main
  @nbayes     = NBayes::Base.new

  #treinamento dos algoritimos baseados no data-set
  impo_train_negative
  impo_train_positive

  #Teste de classificação dos algoritimos

  classify_positive
  classify_negative
end

def format_string(string)
  string.delete('<br>').delete('</br>').delete("\\").delete("\"")
end

def classify_positive
    #importa todos os dados da classe
  entries = Dir.entries('/mnt/c/aclImdb/test/pos') 
  p 'rodando algoritimo comentarios positivos'
  positive = 0
  negative = 0
  tot_input = 1000
  tot_input.times do |index|
    entry = entries[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data_test(entry, 'pos')
    comment = format_string(comment)
    result = @nbayes.classify(comment.split(/\s+/))
    if result.max_class.eql?('GOOD')
      positive += 1 
    else
      negative += 1 
    end

    # p result['BAD']
    # p result['GOOD']
  end

  #calcula porcentagem de acerto
  percent = positive.to_f/tot_input.to_f

  p "Acertou #{positive} de 1000"
  p "Confiabilidade do algoritimo #{percent * 100.0}%"
end

def classify_negative
  #importa todos os dados da classe
  entries_ng = Dir.entries('/mnt/c/aclImdb/test/neg') 
  p 'rodando algoritimo comentarios negativos'
  positive = 0
  negative = 0
  tot_input = 1000

  tot_input.times do |index|
    entry = entries_ng[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data_test(entry, 'neg')
    comment = format_string(comment)
    result = @nbayes.classify(comment.split(/\s+/))
    if result.max_class.eql?('GOOD')
      positive += 1 
    else
      negative += 1 
    end

    # p result['BAD']
    # p result['GOOD']
  end
  p "Acertou #{negative} de 1000"
  percent = negative.to_f/tot_input.to_f
  p tot_input
  p negative
  percent = percent * 100.0
  p "Confiabilidade do algoritimo #{percent}%"
end

def get_file_data_test(file_name, type)
  file = File.open("/mnt/c/aclImdb/test/#{type}/#{file_name}", "r")
  data = file.read
  file.close
  return data
end

def impo_train_positive
  entries = Dir.entries('/mnt/c/aclImdb/train/pos') 
  
  1000.times do |index|
    entry = entries[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data(entry, 'pos')
    comment = format_string(comment)
    train_positive(comment)
  end
end

def train_positive(comment)
  @nbayes.train(comment.split(/\s+/), 'GOOD')
end

def impo_train_negative
  entries = Dir.entries('/mnt/c/aclImdb/train/neg') 
  
  1000.times do |index|
    entry = entries[index]
    next if ['.', '..'].include?(entry)
    comment = get_file_data(entry, 'neg')
    comment = format_string(comment)
    train_negative(comment)
  end

end

def get_file_data(file_name, type)
  file = File.open("/mnt/c/aclImdb/train/#{type}/#{file_name}", "r")
  data = file.read
  file.close
  return data
end

def train_negative(comment)
  @nbayes.train(comment.split(/\s+/), 'BAD')
end

main
