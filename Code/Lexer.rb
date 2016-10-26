# Cory W. Cordell
# Michael Nguyen


require 'strscan'

class Lexer
  @@tokenHash = {
      'assign' => 0,
      'while' => 1,
      'do' => 2,
      'if' => 3,
      'then' => 4,
      'else' => 5,
      'end' => 6,
      'not' => 7,
      'and' => 8,
      'or' => 9,
      'true' => 10,
      'false' => 11,
      'lessOrEqual' => 12,
      'greaterOrEqual' => 13,
      'equal' => 14,
      'lessThan' => 15,
      'greaterThan'=> 16,
      'plus' => 17,
      'minus' => 18,
      'times' => 19,
      'divide' => 20,
      'simiColon' => 21,
      'integer'=> 22,
      'identifier' => 23,
      'openParen' => 24,
      'closeParen' => 25,
      'eof' => 26
  }

  @@parsedTokens = []
  @@tokenIndex = -1
  @@error = false
  @@errorMsg = ''

  def initialize(file)
    parseFile(file.strip)
  end

  def hasError?
    return @@error
  end

  def getErrorMsg
    return @@errorMsg
  end

  def error(s)
    @@error = true
    @@errorMsg = s
  end

  def tokenIndex()
    return @@tokenIndex
  end

  def hasNext?()
    return @@parsedTokens.length > (@@tokenIndex + 1)
  end

  def tokenKindPeek()
    if hasNext?
      return @@parsedTokens[@@tokenIndex + 1]
    else
      return false
    end
  end

  def getTokenKind()
    if hasNext?
      @@tokenIndex += 1
      return @@parsedTokens[@@tokenIndex]
    else
      return false
    end
  end

  def getTokenText(token)
    return "<#{@@tokenHash.key(token)}>"
  end

  def getTokenSymbol(token)
    return @@tokenHash[token]
  end

  def audit(line, tokens, lineNumber)
    puts "#{lineNumber}: #{line}"
    print tokens, "\n\n"
  end

  def parseFile(file)
    audit = false
    tokens = []
    lineNumber = 0

    File.open(file, 'rb').each do |line|
      lineNumber += 1
      line = line.strip
      if line.length > 0
        temp = parse(line)
        if temp
          tokens << temp if temp.length > 0
          audit(line, temp, lineNumber) if audit
        else
          # print tokens
          error("Parse Error: Invalid syntax on line #{lineNumber}, \"#{line.strip}\"")
          break
        end
      end
    end

    tokens << [@@tokenHash['eof']]
    @@parsedTokens = tokens.flatten
  end

  def parse(line)
    audit = false
    x = StringScanner.new(line)
    tokens = []
    last = -1

    while ((x.pos != last) and (not x.eos?))
      last = x.pos

      if x.scan(/\s*\/\//)
        return tokens
      elsif x.scan(/\s*:=/)
        tokens << @@tokenHash['assign']
      elsif x.scan(/\s*while\s/i)
        tokens << @@tokenHash['while']
      elsif x.scan(/\s*do/i)
        tokens << @@tokenHash['do']
      elsif x.scan(/\s*if\s/i)
        tokens << @@tokenHash['if']
      elsif x.scan(/\s*then/i)
        tokens << @@tokenHash['then']
      elsif x.scan(/\s*else/i)
        tokens << @@tokenHash['else']
      elsif x.scan(/\s*end/i)
        tokens << @@tokenHash['end']
      elsif x.scan(/\s*not\s/i)
        tokens << @@tokenHash['not']
      elsif x.scan(/\s*and\s/i)
        tokens << @@tokenHash['and']
      elsif x.scan(/\s*or\s/i)
        tokens << @@tokenHash['or']
      elsif x.scan(/\s*true\s/i)
        tokens << @@tokenHash['true']
      elsif x.scan(/\s*false\s/i)
        tokens << @@tokenHash['false']
      elsif x.scan(/\s*<=/)
        tokens << @@tokenHash['lessOrEqual']
      elsif x.scan(/\s*>=/)
        tokens << @@tokenHash['greaterOrEqual']
      elsif x.scan(/\s*=/)
        tokens << @@tokenHash['equal']
      elsif x.scan(/\s*</)
        tokens << @@tokenHash['lessThan']
      elsif x.scan(/\s*>/)
        tokens << @@tokenHash['greaterThan']
      elsif x.scan(/\s*\+/)
        tokens << @@tokenHash['plus']
      elsif x.scan(/\s*-/)
        tokens << @@tokenHash['minus']
      elsif x.scan(/\s*\*/)
        tokens << @@tokenHash['times']
      elsif x.scan(/\s*\//)
        tokens << @@tokenHash['divide']
      elsif x.scan(/\s*;/)
        tokens << @@tokenHash['simiColon']
      elsif x.scan(/\s*-?[0-9]+/)
        tokens << @@tokenHash['integer']
      elsif x.scan(/\s*[a-zA-z][_a-zA-Z0-9]*/)
        tokens << @@tokenHash['identifier']
      elsif x.scan(/\s*\(/)
        tokens << @@tokenHash['openParen']
      elsif x.scan(/\s*\)/)
        tokens << @@tokenHash['closeParen']
      else
        return false
      end
    end
    audit(line, tokens, '*') if audit
    return tokens
  end

  def getTokensSting()
    s = ''
    @@parsedTokens.length.times {s += "#{getTokenKind()}, "}
    return s.chomp(', ')
  end

  def tokenize()
    s = ''
    @@parsedTokens.each {|x| s += getTokenText(x)}
    return s
  end
end
