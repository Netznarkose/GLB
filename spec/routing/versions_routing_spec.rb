require 'spec_helper'

describe VersionsController, type: :routing do
  describe 'routing' do
    it 'routes to #revert' do
      expect(post('/versions/1/revert')).to route_to('versions#revert', id: '1')
    end
  end
end
