# Cory W. Cordell
# Michael Nguyen


require_relative 'Analyzer.rb'

if __FILE__ == $0
  testAllSymbols = '../SimPLSamples/testAllSymbols.txt'
  goodCode = '../SimPLSamples/goodCode.txt'
  badCode = '../SimPLSamples/badCode.txt'

  puts 'Test Analyzer'
  puts a = Analyzer.new(badCode)
end