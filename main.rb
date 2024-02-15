$state_game = [
  [0,0,0],
  [0,0,0],
  [0,0,0]
]
$HUMAN = -1
$COMP = 1


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
  morreu = empty_block.length
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

def minimax(state, depth, player)
  # Funcao da IA que escolhe o melhor movimento
  # Profundida é quantas rodadas ainda falta

  if player == 1 # Igual IA
    best = [-1,-1,-2]
  else
    best = [-1,-1,+2]
  end


  if depth == 0 or game_over()
    score = evaluate()
    return [-1,-1,score]
  end

  empty_block().each do |cell|
    # Ele passa por cada bloco vazio
    # Posicao do bloco
    x, y = cell[0], cell[1]
    # A copia do jogo recebe a jogada da ia nesse bloco
    state[x][y] = player
    # Inverte o jogador e faz o teste e recebe o score do minimax
    # score_mm = [x,y,score]
    score_mm = minimax(state, depth -1, -player)
    # O quadro volta para como estava
    state[x][y] = 0
    # score_mm recebe a posicao x e y do bloco que esta sendo visto
    score_mm[0], score_mm[1] = x, y

    if player == 1
      if score_mm[2] > best[2]
        best = score_mm # Max valor
      end
    else
      if score_mm[2] < best[2]
        best = score_mm # Min valor
      end
    end
  end

  return best
end

def deep_copy(array)
  array.map do |sub_array|
    if sub_array.is_a?(Array)
      deep_copy(sub_array)
    else
      sub_array
    end
  end
end


def ai_turn(computer, jogador)
  #

  depth = empty_block().length
  # Se o jogo acabou acaba por aqui
  if depth == 0 or game_over()
    return
  end

  print("Computer turn [#{computer}]")
  render(computer, jogador)

  # Copia da funcao do quadro
  #state_copy = deep_copy($state_game)
  # Recebe o movimento que deve fazer
  move = minimax($state_game, depth, 1)
  # [x,y,0]
  # (-1 = se vai perder caso o adversario tome as melhores decisoes)
  # (0 = se vai dar empete caso oadversio tome as melhores decisoes)
  # (1 = Ganhar 100%)
  x, y = move[0], move[1]
  print("Pensamento IA: #{move}")
  # Faz o movimento
  set_move(x,y,1)

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
  while empty_block.length > 0 and not game_over()
    if jogador == "X" and i == 0
      i = 1
      human_turn(computer, jogador)
    end
    ai_turn(computer, jogador)
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
