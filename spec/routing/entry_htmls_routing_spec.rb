require 'spec_helper'

describe EntryHtmlsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get('/entry_htmls/1/')).to route_to('entry_htmls#show', id: '1')
    end
  end
end
