require 'spec_helper'

describe EntryVersionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/entries/1/entry_versions')).to route_to(controller: 'entry_versions', action: 'index', entry_id: '1')
    end

    it 'routes to #show' do
      expect(get('/entries/1/entry_versions/1')).to route_to(controller: 'entry_versions', action: 'show', entry_id: '1', id: '1')
    end
  end
end
