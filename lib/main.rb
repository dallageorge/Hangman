  require 'yaml'

  class Game
    def gameRun()
      puts "Enter 0 if you wanna start a new game or 1 to load the last save."
      startchoice = gets.strip

      loop do
        if startchoice=='0' || startchoice=='1'
          startchoice= startchoice.to_i
          break
        else
          puts "Wrong Input, try again:"
          startchoice = gets.strip
        end
      end


      if startchoice==1
        vars_array= YAML.load(File.read("save.yml"))
        word, guess_so_far, letters_so_far,countinc = vars_array
        puts "Letters tried so far:"
        puts letters_so_far
        puts "Wrong attempts so far:"
        puts countinc
        puts guess_so_far
        gamerounds(word,guess_so_far,letters_so_far,countinc)
      else

        
        isfound=false
        file = File.readlines("google-10000-english-no-swears.txt")



        while !isfound do
          selection = rand(9999)
          word = file[selection].strip
          if word.length.between?(5,12)
            isfound=true
          end
        end
        letters_so_far = []
        able_to_play = true
        guess_so_far = "_"*word.length
        puts "Word:"+ guess_so_far
        countinc=0
        gamerounds(word,guess_so_far,letters_so_far,countinc)
      end
    end
    def choiceWord(word)
      puts "Enter the word:"
      guessedword = gets.downcase.strip 
      if guessedword == word 
        return true
      else 
        return false
      end
    end 

    def choiceLetter(word,guess_so_far,letters_so_far,countinc)
      puts "Please guess a letter:"
      guess = gets.downcase[0]
      while (letters_so_far.include?(guess)) do
        puts "You already tried that letter, try another one:"
        guess = gets.downcase[0]
      end
      letters_so_far.append(guess)

      if word.length==5
        amountoftries=6
      else
        amountoftries=word.length
      end
      if !(word.include?(guess))
        countinc=countinc+1
        puts countinc.to_s + " incorrect guesses done. "+(amountoftries-countinc).to_s + "left. "
      else
        puts countinc.to_s + " incorrect guesses done. "+(amountoftries-countinc).to_s + "left. "
      
      end
      
      word.each_char.with_index do |letter,index|
        if  guess == letter
          guess_so_far[index] = guess
        end
      end
      puts guess_so_far
      return guess_so_far ,letters_so_far, countinc
    end

    def gamerounds(word,guess_so_far,letters_so_far,countinc)
      puts "enter  0 if you wanna guess letter, 1 to guess the word"

      selchoice = gets.strip

      loop do
        if selchoice=='0' || selchoice=='1'
          selchoice=selchoice.to_i
          break
        else
          puts "Wrong Input, try again:"
          selchoice = gets.strip
        end
      end

      if word.length==5
        amountoftries=6
      else amountoftries=word.length
      end

      guessed_all_letters=false

      while selchoice == 0 && countinc < amountoftries do
        guess_so_far,letters_so_far, countinc = choiceLetter(word,guess_so_far,letters_so_far,countinc)
        if !guess_so_far.include?('_')
          guessed_all_letters = true
          break
        end
        if amountoftries==countinc
          break
        end
        if countinc !=amountoftries
          puts "enter 2 if you want to save the current game, else press enter."
          savecheck = gets.strip.to_i
          if savecheck==2
            gamevars = [word, guess_so_far, letters_so_far,countinc]
            File.open("save.yml", "w") { |file| file.write(gamevars.to_yaml) }
            puts "Game Saved."
            break 
          else
            puts "enter  0 if you wanna guess letter, 1 to guess the word"
            loop do
              selchoice = gets.strip
              if selchoice=='0' || selchoice=='1'
                selchoice=selchoice.to_i
                break
              else
                puts "Wrong Input, try again :"
              end
            end
          end
        end
      end
      if savecheck!=2
        if selchoice == 0
          if guessed_all_letters == true 
            puts "You won. Word was:"+word
          else
            puts "You lost. Word was:"+word
          end
        end

        if selchoice == 1
          won= choiceWord(word)
          if won == true
            puts "You won. Word was:"+word
          else
            puts "You lost. Word was:"+word
          end
        end
      end  
    end


  end








  g = Game.new
  g.gameRun