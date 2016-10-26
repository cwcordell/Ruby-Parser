# Cory W. Cordell
# Michael Nguyen


require_relative 'Lexer.rb'
# @@types = ['program','stmts','stmt','addop','mulop','factor','lexpr','lterm','lfactor','relop']

class Analyzer

  def initialize(file)
    @lexer = Lexer.new(file)
    @currentToken = -1
    @error = false
    @errorMsg = ["The file contains errors:"]
    @successMsg = 'The program compiled successfully!'
    nextToken
    puts "\n"

    if @lexer.hasError?
      @error = true
      @errorMsg << @lexer.getErrorMsg
    elsif eof?
      error 'The file is empty!'
    else
      program()
    end

    if hasError?
      puts getErrorMsg
    else
      puts getSuccessMsg
    end
  end

  def hasError?
    @error
  end

  def getErrorMsg
    @errorMsg
  end

  def getSuccessMsg
    @successMsg
  end

  def error(s = '')
    @error = true
    @errorMsg << "Error at token index #{@lexer.tokenIndex}: " + s
  end

  def currentToken()
    @currentToken
  end

  def consumeToken()
    @currentToken = -1
  end

  def nextToken()
    if currentToken < 0
      @currentToken = @lexer.getTokenKind
    end

    currentToken
  end

  def nextEquals?(token)
    # puts currentToken
    # puts nextToken
    if nextToken == @lexer.getTokenSymbol(token)
      # puts 'consume-true'
      consumeToken
      nextToken
      return true
    else
      # puts 'consume-false'
      return false
    end
  end

  def eof?()
    currentToken == @lexer.getTokenSymbol('eof')
  end

  def getTokenSymbol(token = currentToken)
    @lexer.getTokenSymbol(token)
  end

  def tokenize()
    @lexer.tokenize()
  end

  def program()
    lastToken = -2

    while lastToken != nextToken && !eof? && !hasError?
      lastToken = currentToken

      if stmts() != '<stmts>'
        error('Not a Program!')
      end
    end
  end

  def stmts()
    # puts 'in stmts'
    # puts nextToken
    # if nextToken == getTokenSymbol('simiColon')
    #   if @lexer.tokenIndex > 0
    #     consumeToken
    #     return '<stmts>'
    #   else
    #     error('Improper placement of simi-colon!')
    #   end
    # els
    if stmt == '<stmt>'
      if nextToken == getTokenSymbol('simiColon')
        # puts currentToken
        consumeToken
        # puts currentToken
        return '<stmts>'
      else
        error('Missing Simi-Colon!')
      end
    end

    error('No statements!')
    false
  end

  def stmt()
    # puts 'in stmt'
    # puts nextToken
    sym = '<stmt>'

    if nextToken == getTokenSymbol('identifier')
      consumeToken
      if nextToken == getTokenSymbol('assign')
        # puts currentToken
        consumeToken
        if addop == '<addop>'
          # puts 'return on addop'
          return sym
        else
          error('No addop!')
        end
      else
        error("Expected assignment ':='!")
      end
    elsif nextToken == getTokenSymbol('if')
      consumeToken
      if lexpr == '<lexpr>'
        if nextEquals?('then')
          if stmts == '<stmts>'
            # puts 'check stmts'
            hasStmts = true
            while hasStmts && !(nextToken == @lexer.getTokenSymbol('else'))
              hasStmts = (stmts == '<stmts>')
            end
            # puts 'done'
            # puts currentToken

            if nextEquals?('else')
              if stmts == '<stmts>'
                # puts 'check stmts'
                hasStmts = true
                while hasStmts && !(nextToken == @lexer.getTokenSymbol('end'))
                  hasStmts = (stmts == '<stmts>')
                end
                # puts 'done'
                # puts currentToken

                if nextEquals?('end')
                  return sym
                else
                  error("No 'end' token found in 'if condition'!")
                end
              else
                error("Improper statement in 'if-else condition'!")
              end
            else
              error("No 'else' token found in 'if condition'!")
            end
          else
            error("Improper statement in 'if-then condition'!")
          end
        else
            error("No 'then' token found in 'if condition'!")
        end
      else
        error("Improper boolean in 'if condition'!")
      end
    elsif nextToken == getTokenSymbol('while')
      # puts currentToken
      consumeToken
      # puts currentToken
      if lexpr == '<lexpr>'
        # puts 'in'
        if nextEquals?('do')
          if stmts == '<stmts>'
            # puts 'check stmts'
            hasStmts = true
            while hasStmts && !(nextToken == @lexer.getTokenSymbol('end'))
              hasStmts = (stmts == '<stmts>')
            end
            # puts 'done'
            # puts currentToken

            if nextEquals?('end')
              # puts 'at end'
              return sym
            else
              error("No 'end' token found in 'while loop'!")
            end
          else
            error("Improper statement in 'while loop'!")
          end
        else
          error("No 'do' token found in 'while loop'!")
        end
      else
        error("Improper boolean in 'while loop'!")
      end
    end

    error('Not a statement!')
    false
  end

  def addop()
    # puts 'addop'
    # puts nextToken
    if mulop == '<mulop>'
      if nextEquals?('plus') or nextEquals?('minus')
        if addop == '<addop>'
          return '<addop>'
        else
          error('Missing the right op (addop)!')
          return false
        end
      end
      return '<addop>'
    end

    error('Not an addop!')
    false
  end

  def mulop()
    # puts 'mulop'
    # puts nextToken
    if factor == '<factor>'
      if nextEquals?('times') or nextEquals?('divide')
        if mulop == '<mulop>'
          return '<mulop>'
        else
          error('Missing the right op (mulop)!')
          return false
        end
      end
      return '<mulop>'
    end

    error('Not an mulop!')
    false
  end

  def factor()
    if nextEquals?('integer') or nextEquals?('identifier')
      return '<factor>'
    elsif nextEquals?('openParen')
      if addop == '<addop>'
        if nextEquals?('closeParen')
          return '<factor>'
        elsif
          error('Missing the closing parenthesis!')
          return false
        end
      else
        error('Missing the addop after an opening parenthesis!')
        return false
      end
    end

    error('Not a factor!')
    false
  end

  def lexpr()
    # puts 'lexpr'
    # puts nextToken
    if lterm == '<lterm>'
      if nextEquals?('and')
        if lexpr == '<lexpr>'
          return '<lexpr>'
        end
      elsif nextEquals?('or')
        if lexpr == '<lexpr>'
          return '<lexpr>'
        end
      end
      return '<lexpr>'
    end

    error('Not a lexpr!')
    false
  end

  def lterm()
    # puts 'lterm'
    # puts nextToken
    if nextEquals?('not')
      if lfactor == '<lfactor>'
        return '<lterm>'
      else
        error 'Missing lfactor'
      end
    elsif lfactor == '<lfactor>'
      return '<lterm>'
    end

    error('Not a lterm!')
    false
  end

  def lfactor()
    # puts 'lfactor'
    # puts nextToken
    if nextEquals?('true') or nextEquals?('false') or relop == '<relop>'
      return '<lfactor>'
    end

    error('Not a lfactor!')
    false
  end

  def relop()
    # puts 'relop'
    # puts nextToken
    if addop == '<addop>'
      if nextEquals?('lessThan')
        if addop == '<addop>'
          return '<relop>'
        else
          error('Missing the right addop!')
        end
      elsif nextEquals?('lessOrEqual')
        if addop == '<addop>'
          return '<relop>'
        else
          error('Missing the right addop!')
        end
      elsif nextEquals?('greaterThan')
        if addop == '<addop>'
          return '<relop>'
        else
          error('Missing the right addop!')
        end
      elsif nextEquals?('greaterOrEqual')
        if addop == '<addop>'
          return '<relop>'
        else
          error('Missing the right addop!')
        end
      elsif nextEquals?('equal')
        if addop == '<addop>'
          return '<relop>'
        else
          error('Missing the right addop!')
        end
      else
        error('Missing the equality!')
      end
    end

    error('Not a relop!')
    false
  end
end