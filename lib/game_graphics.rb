def gallow_graphics(turns_remaining)
  case turns_remaining
  when 7
    puts '
  ||  
  ||
  ||
  ||
  ||'
  when 6
    puts ' ————
  ||  |
  ||
  ||
  ||
  ||'
  when 5
    puts ' ————
  ||  |
  ||  0
  ||
  ||
  ||'
  when 4
    puts ' ————
  ||  |
  ||  0
  ||  |
  ||
  ||'
  when 3
      puts ' ————
  ||  |
  ||  0
  || /|
  ||
  ||'
  when 2
    puts ' ————
  ||  |
  ||  0
  || /|\
  ||
  ||'
  when 1
    puts ' ————
  ||  |
  ||  0
  || /|\
  || /
  ||'
  when 0
    puts ' ————
  ||  |
  ||  0
  || /|\
  || / \
  ||
  Game Over!'
  end
  end