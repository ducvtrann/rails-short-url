class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, presence: true
  validate :validate_full_url

  def short_code
    return if self.id == nil
    encode(self.id)
  end

  # function returns Model.primary_key
  def long_code(hash_str)
    return if hash_str == nil
    decode(hash_str)
  end

  def update_title!
  end

  private

  def validate_full_url
    begin
      url = URI.parse(self.full_url)
      response = Net::HTTP.get(url)
      true if response.is_a?(Net::HTTPSuccess)
    rescue StandardError => error
      self.errors[:full_url] << 'is not a valid url'
      false
    end
  end

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
