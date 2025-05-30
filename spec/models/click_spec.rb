# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it 'validates url_id is valid' do
      click = Click.new(browser: 'browser', platform: 'platform')
      expect(click).to be_invalid
    end

    it 'validates browser is not null' do
      click = Click.new(url_id: 1, platform: 'platform')
      expect(click).to be_invalid
    end

    it 'validates platform is not null' do
      click = Click.new(url_id: 1, browser: 'browser')
      expect(click).to be_invalid
    end

    it 'validates platform persists' do
      Url.create(short_url: Url.next_short_url, original_url: 'http://www.google.com')
      click = Click.new(url_id: Url.all.first.id, platform: 'platform', browser: 'browser')
      expect(click).to be_valid
    end
  end
end
