require 'spec_helper'
describe HomeController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/hundredlemma')).to route_to('home#hundredlemma')
    end 
  end
end
