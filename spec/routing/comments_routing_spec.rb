require 'spec_helper'

describe CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #edit' do
      expect(get('/entries/1/comments/1/edit')).to route_to(
        controller: 'comments', action: 'edit', entry_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post('/entries/1/comments')).to route_to(
        controller: 'comments', action: 'create', entry_id: '1')
    end

    it 'routes to #update' do
      expect(put('/entries/1/comments/1')).to route_to(
        controller: 'comments', action: 'update', entry_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/entries/1/comments/1')).to route_to(
        controller: 'comments', action: 'destroy', entry_id: '1', id: '1')
    end
  end
end
