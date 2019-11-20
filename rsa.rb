# frozen_string_literal: true

# Implementa função 'modular exponentiation', porque no URI a versão e
# do ruby é a 2.3, e ela so foi implementada a partir da versão 2.5.
# Também não é possivel utilizar (c**d) % n porque o número do expoente pode
# ser muito grande, gerando erro.
# Outra solução poderia ser c.to_bn.mod_exp(d, n), mas não é possivel importar a
# a biblioteca 'openssl'
def mod_exp(n, e, mod)
  raise ArgumentError, 'negative exponent' if e.negative?

  prod = 1
  base = n % mod
  until e.zero?
    prod = (prod * base) % mod if e.odd?
    e >>= 1
    base = (base * base) % mod
  end
  prod
end

# Encontra o menor primo que divide o númeor n
def find_prime(number)
  i = 3
  while i <= (number / 2)
    return i if (number % i).zero?

    i += 2
  end
end

# Calcula o totiente
def totiente(number)
  p = find_prime(number)
  q = number / p
  (p - 1) * (q - 1)
end

# Calcula GCD estendido
def extended_gcd(a, b)
  return b, 0, 1 if a.zero?

  g, y, x = extended_gcd(b % a, a)
  [g, x - (b / a).floor * y, y]
end

def invmod(a, m)
  g, x, _y = extended_gcd(a, m)
  raise 'The maths are broken!' if g != 1

  x % m
end

# Calcula o inverso multiplicativo
def multiplicative_inverse(n, e)
  totiente = totiente(n)
  invmod(e, totiente)
end

# Descriptografa a mensagem
def decrypt(n, e, c)
  d = multiplicative_inverse(n, e)
  # (c**d) % n
  # c.pow(d, n)
  # c.to_bn.mod_exp(d, n)
  mod_exp(c, d, n)
end

input = gets.chomp
n, e, c = input.split(' ').map(&:to_i)
puts decrypt(n, e, c)

# lines = readlines
# lines.each do |line|
#   n, e, c = line.split(' ').map(&:to_i)
#   puts decrypt(n, e, c)
# end
