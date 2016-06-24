require 'spec_helper'

describe TutorialController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/tutorial')).to route_to('tutorial#index')
    end
  end
end
