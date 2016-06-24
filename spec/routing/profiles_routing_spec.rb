require 'spec_helper'

describe ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #edit' do
      expect(get('/profile/edit')).to route_to('profiles#edit')
    end

    it 'routes to #update' do
      expect(put('/profile/')).to route_to('profiles#update')
    end
  end
end
