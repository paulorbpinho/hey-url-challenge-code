# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    load_recent_urls
  end

  def create
    # create a new URL record
    @url = Url.new(url_params)
    @url.short_url = Url.next_short_url
    @url.created_at = Time.now

    respond_to do |format|
      if @url.save
        flash[:notice] = "Url was successfully created."
        format.html { redirect_to action: :index }
      else
        load_recent_urls
        format.html { render action: :index }
      end
    end
  end

  def show
    @url = Url.find_by(short_url: params[:url])
    # implement queries
    @daily_clicks = [
      ['1', 13],
      ['2', 2],
      ['3', 1],
      ['4', 7],
      ['5', 20],
      ['6', 18],
      ['7', 10],
      ['8', 20],
      ['9', 15],
      ['10', 5]
    ]
    @browsers_clicks = [
      ['IE', 13],
      ['Firefox', 22],
      ['Chrome', 17],
      ['Safari', 7]
    ]
    @platform_clicks = [
      ['Windows', 13],
      ['macOS', 22],
      ['Ubuntu', 17],
      ['Other', 7]
    ]
  end

  def visit
    browser = Browser.new(request.user_agent)
    @url = Url.find_by(short_url: params[:short_url])
    @url.update!(clicks_count: @url.clicks_count + 1)
    @url.clicks.create(browser: browser.name, platform: browser.platform)
    redirect_to @url.original_url
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def load_recent_urls
    @urls = Url.order(:created_at).limit(10)
  end
end
