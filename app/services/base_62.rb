module Base62
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  # BASE_62 ENCODING
  def encode(number)
    hash_str = ''

    while (number > 0)
      hash_str = CHARACTERS[number % 62] + hash_str
      number /= 62
    end

    hash_str
  end

  # BASE_62 DECODING
  def decode(hash_str)
    base_10_num = 0
    digit = 0

    hash_str.reverse.each_char do |char|
      num = CHARACTERS.index(char)
      base_10_num += num * (62 ** digit)
      digit += 1
    end

    base_10_num
  end
end
