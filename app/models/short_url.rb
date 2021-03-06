class ShortUrl < ApplicationRecord
  include Base62

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
    URI.open("#{self.full_url}") do |f|
      document = Nokogiri::HTML(f)
      title = document.at_css('title').text
      self.update_attribute(:title, title)
    end
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
end
