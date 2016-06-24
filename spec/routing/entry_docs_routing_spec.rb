require 'spec_helper'

describe EntryDocsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get('/entry_docs/1/')).to route_to('entry_docs#show', id: '1')
    end
  end
end
