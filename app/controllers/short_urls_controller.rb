class ShortUrlsController < ApplicationController
  include Base62
  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: {urls: urls}
  end

  def create
    short_url = ShortUrl.new(full_url: params[:full_url])

    if short_url.save
      Resque.enqueue(UpdateTitleJob, short_url.id)
      render json: { short_code: short_url.short_code }
    else
      short_url.errors.full_messages << 'Full url is not a valid url'
      render json: { errors: short_url.errors.full_messages }, status: 404
    end
  end

  def show
    url_id = decode(params[:id])
    url = ShortUrl.find_by(id: url_id)

    if url
      url.update_attribute(:click_count, url[:click_count] + 1)
      redirect_to url.full_url
    else
      render json:  {}, status: 404
    end
  end

end
