# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      Url.create(short_url: "ABCDE", original_url: 'http://www.google.com')
      visit root_path
      expect(page).to have_text('ABCDE')
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      Url.create(short_url: "ABCDE", original_url: 'http://www.google.com')
      visit url_path('ABCDE')
      expect(page).to have_text('ABCDE')
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        expect(page).to have_text('The page you were looking for doesn\'t exist.')
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'
        within('#new_url') do
          fill_in 'url_original_url', with: 'http://www.google.com.br'
        end
        click_button('Shorten URL')
        expect(page).to have_content 'Url was successfully created.'
      end

      it 'redirects to the home page' do
        visit '/'
        within('#new_url') do
          fill_in 'url_original_url', with: 'http://www.google.com.br'
        end
        click_button('Shorten URL')
        expect(page).to have_content 'Create a new short URL'
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        within('#new_url') do
          fill_in 'url_original_url', with: 'a'
        end
        click_button('Shorten URL')
        expect(page).to have_content 'Original url is not a valid URL'
      end

      it 'redirects to the home page' do
        visit '/'
        within('#new_url') do
          fill_in 'url_original_url', with: 'a'
        end
        click_button('Shorten URL')
        expect(page).to have_content 'Create a new short URL'
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      Url.create(short_url: "ABCDE", original_url: 'http://www.google.com')
      visit visit_path('ABCDE')
      expect(page).to have_content 'Google'
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        expect(page).to have_text('The page you were looking for doesn\'t exist.')
      end
    end
  end
end
