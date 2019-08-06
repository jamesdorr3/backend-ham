require 'rails_helper'
describe 'App opens', type: :feature, js: true do
  # let(:variable_a) { ... }
  before do
    visit('http://localhost:3000/')
  end
  context 'App opens' do
    # before { page.find('.learn-more').click }
    it 'brings them to page x' do
      expect(page).to have_current_path('http://localhost:3000/')
    end
  end
  # context 'click on "set up account now"' do
  #   before { page.find('.setup-now').click }
  #   it 'brings them to page y' do
  #     expect(page).to have_current_path('/path-y')
  #   end
  # end
end