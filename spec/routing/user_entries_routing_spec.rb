require 'spec_helper'

describe UserEntriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/users/1/entries')).to route_to('user_entries#index', user_id: '1')
    end
  end
end
