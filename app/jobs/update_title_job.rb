require 'open-uri'

class UpdateTitleJob < ApplicationJob
  @queue = :update_title
  queue_as :default

  def perform(short_url_id)
    pp 'WHYYYY', short_url_id
    pp 'I am running'
    url = ShortUrl.find_by(id: short_url_id)
    open("#{url.full_url}") do |f|
      document = Nokogiri::HTML(f)
      title = document.at_css('title').text
      url.update_attribute(:title, title)
      pp 'I am done'
    end
  end
end
