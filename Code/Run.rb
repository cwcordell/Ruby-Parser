# Cory W. Cordell
# Michael Nguyen


require_relative 'Analyzer.rb'

class Run
  # testFiles = ['../SimPLSamples/goodCode.txt', '../SimPLSamples/badCode.txt', '../SimPLSamples/badSymbolsCode.txt', '../SimPLSamples/emptyFile.txt', '../SimPLSamples/test.txt']

  def go
    puts "\n"
    path = gets.strip

    if File.file?(path)
      Analyzer.new(path)
    else
      puts "\nThe file path entered does not exist.\n\nExiting the program ...\n\n"
    end
  end
end

if __FILE__ == $0
  Run.new.go
end