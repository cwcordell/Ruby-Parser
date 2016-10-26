# Cory W. Cordell
# Michael Nguyen


require_relative 'Lexer.rb'

if __FILE__ == $0
  testAllSymbols = '../SimPLSamples/testAllSymbols.txt'
  goodCode = '../SimPLSamples/goodCode.txt'
  badCode = '../SimPLSamples/badCode.txt'
  badSymbolsCode = '../SimPLSamples/badSymbolsCode.txt'
  emptyFile = '../SimPLSamples/emptyFile.txt'

  puts 'Test Lexer'
  l = Lexer.new(emptyFile)

  puts l.getTokenText 23
  puts l.getTokensSting
  puts l.tokenize
end