require 'open-uri'

class UpdateTitleJob < ApplicationJob
  @queue = :update_title_job
  queue_as :default

  def perform(short_url_id)
    Resque.logger = Logger.new("#{Rails.root}/log/resque.log")
    Resque.logger.level = Logger::DEBUG

    Resque.logger.info 'Job starts'
    Resque.logger.info "short_url_id - #{short_url_id}"

    url = ShortUrl.find_by(id: short_url_id)

    Resque.logger.info "url - #{url}"

    open("#{url.full_url}") do |f|
      document = Nokogiri::HTML(f)
      title = document.at_css('title').text
      url.update_attribute(:title, title)
      Resque.logger.info "updated URL - #{url}"
    end
  end
end
