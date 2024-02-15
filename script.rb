$state_game = [
  [0,1,-1],
  [0,0,0],
  [0,0,0]
]
# Função para criar uma cópia profunda da lista
def deep_copy(array)
  array.map do |sub_array|
    if sub_array.is_a?(Array)
      deep_copy(sub_array)
    else
      sub_array
    end
  end
end

# Usando clone
copied_state_game = deep_copy($state_game)

# OU usando dup
# copied_state_game = $state_game.dup

# Modificando a cópia
copied_state_game[0][0] = 1

# Imprimindo as listas originais e modificadas
puts "Lista original: #{$state_game}"
puts "Cópia modificada: #{copied_state_game}"
