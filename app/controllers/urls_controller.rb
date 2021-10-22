# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    load_recent_urls
    respond_to do |format|
      format.html
      format.json { render json: {
          data: @urls,
          included: @urls.map { |url| url.clicks.map { |click| click.as_json(nil) } }
        } 
      }
    end
  end

  def create
    # create a new URL record
    @url = Url.new(url_params)
    @url.short_url = Url.next_short_url
    if @url.save
      flash[:notice] = "Url was successfully created."
      redirect_to action: :index
    else
      load_recent_urls
      render action: :index
    end
  end

  def show
    @url = Url.find_by(short_url: params[:url])
    if @url
      @clicks = Click.where(created_at: Date.today.at_beginning_of_month.midnight..Date.today.end_of_month.end_of_day)
      @daily_clicks = []
      @click_days = @clicks.group_by { |click| click.created_at.to_date }
      @click_days.each do |day, clicks|
        @daily_clicks.push([day.mday.to_s, clicks.length])
      end
      @browsers_clicks = []
      @click_browser = @clicks.group_by { |click| click.browser }
      @click_browser.each do |browser, clicks|
        @browsers_clicks.push([browser, clicks.length])
      end
      @platform_clicks = []
      @click_platform = @clicks.group_by { |click| click.platform }
      @click_platform.each do |platform, clicks|
        @platform_clicks.push([platform, clicks.length])
      end
    else
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  def visit
    browser = Browser.new(request.user_agent)
    @url = Url.find_by(short_url: params[:short_url])
    if @url
      ActiveRecord::Base.transaction do
        @url.clicks.create!(platform: browser.platform, browser: browser.name)
        @url.update!(clicks_count: @url.clicks.length)
      end
      redirect_to @url.original_url
    else
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def load_recent_urls
    @urls = Url.order(:created_at).limit(10)
  end
end
