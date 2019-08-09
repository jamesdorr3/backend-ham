require 'rails_helper'
describe 'App', type: :feature, js: true do
  # let(:variable_a) { ... }
  before do
    visit('http://localhost:3000/')
  end
  context 'opens' do
    # before { page.find('.learn-more').click }
    it 'brings them to home page' do
      expect(page).to have_current_path('http://localhost:3000/')
    end
  end

  context 'signs in' do
    before { fill_in('usernameOrEmail', :with => 'j') }
    it 'brings to login page' do
      expect(page).to have_current_path('http://localhost:3000/')
    end
  end
end

# visit('url')
# page.find('.query?').click
#before {do some shit}