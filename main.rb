
$HUMAN = -1
$COMP = +1


################# Funcoes do Jogo ####################
def wins(player)
  $state_game
  win_state = [
      [$state_game[0][0], $state_game[0][1], $state_game[0][2]],
      [$state_game[1][0], $state_game[1][1], $state_game[1][2]],
      [$state_game[2][0], $state_game[2][1], $state_game[2][2]],
      [$state_game[0][0], $state_game[1][0], $state_game[2][0]],
      [$state_game[0][1], $state_game[1][1], $state_game[2][1]],
      [$state_game[0][2], $state_game[1][2], $state_game[2][2]],
      [$state_game[0][0], $state_game[1][1], $state_game[2][2]],
      [$state_game[2][0], $state_game[1][1], $state_game[0][2]],
  ]

  # Retorna True se o player que esta sendo verificado ganhou
  if win_state.include?([player, player, player])
    return true
  else
    return false
  end
end

def game_over()
  return wins(1) || wins(-1)
end

def empty_block()
  $state_game
  # Retorna uma lista com cada bloco do jogo vazio

  blocks = []

  $state_game.each_with_index do |linha, x|
    linha.each_with_index do |bloco, y|
      if bloco == 0 # Se bloco vazio
        blocks.push([x, y])
      end
    end
  end

  return blocks
end

def set_move(x, y, str_player)
  if empty_block().include?([x,y])
    $state_game[x][y] = str_player
    return true
  else
    return false
  end
end

def render(computer, jogador)
  $state_game

  chars = {
    -1 => jogador,
    +1 => computer,
    0 => '-'
  }

  print("\n" + "-" * 30 + "\n")

  $state_game.each do |row|
    row.each do |bloco|
      # Symbol vai ser = X ou O ele recebe a bloca e sabe o que imprimir
      symbol = chars[bloco]
      print("|#{symbol}|" )
     end
     print("\n")
  end
end

############### Funcao do jogador ###################

def human_turn(computer, jogador)
  $state_game
  morreu = empty_block().length
  if morreu == 0 or game_over()
    return
  end
  move = -1
  moves = {
  1 => [0, 0], 2 => [0, 1], 3 => [0, 2],
  4 => [1, 0], 5 => [1, 1], 6 => [1, 2],
  7 => [2, 0], 8 => [2, 1], 9 => [2, 2]
  }

  print("Humano joga: [#{jogador}]")
  render(computer, jogador)

  while move < 1 or move > 9
    begin
      print 'Use numpad (1..9): '
      move = gets.chomp.to_i
      coordenada = moves[move]
      can_move = set_move(coordenada[0], coordenada[1], -1)

      unless can_move
        puts 'Bad move'
        move = -1
      end
    rescue SystemExit, Interrupt
      puts 'Bye'
      exit
    rescue KeyError, ArgumentError
      puts 'Bad choice'
    end
  end

end

################ Funcoes da IA #######################
def evaluate()
  # IA ganha = 1
  # Humano ganha = -1
  # Empate = 0
  if wins($COMP)
    score = +1
  elsif wins($HUMAN)
    score = -1
  else
    score = 0
  end
  return score
end

infinito = -Float::INFINITY
def minimax(state)
  # Funcao da IA que escolhe o melhor movimento
  # Profundida é quantas rodadas ainda falta

  best = [-1,-1,-infinito]

  if depth == 0 or game_over()
    score = evaluate()
end

def ai_turn()

end

################## main ######################
def main()
  $state_game
  jogador = ""
  computer = ""

  # Caso humano na selecionou nem O e nem X algoritmo repete
  while jogador != "O" and jogador != "X"
    print("Escolha X (1°) ou O (2°):")
    jogador = gets.chomp
  end

  if jogador == "X"
    computer = "O"
  elsif jogador == "O"
    computer = "X"
  end

  i = 0
  # Vai se repetir ate um dos dois for falso
  while empty_block().length > 0 and not game_over()
    if jogador == "X"
      human_turn(computer, jogador)
    end
    ia_turn()
    human_turn(computer, jogador)
  end

  if wins($HUMAN)
    print("Human turn [#{jogador}]")
    render(computer, jogador)
    print('YOU WIN!')
  elsif wins($COMP)
    print("Computer turn [#{computer}]")
    render(computer, jogador)
    print('YOU LOSE!')
  else
    render(computer, jogador)
    print('DRAW!')
  end

end

main()
