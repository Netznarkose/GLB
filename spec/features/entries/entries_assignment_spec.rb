require 'spec_helper'

describe 'assignments' do
  let(:admin) { create(:admin) }
  let(:editor) { create(:editor) }
  let(:entry) { create(:entry) }
  let(:assignment) { create(:assignment) }

  describe 'entry#edit template' do
    context 'as admin' do
      before do
        login_as_user(admin)
      end
      context 'unassigned entry' do
        it 'sees link Zuweisen' do
          visit edit_entry_path(entry)
          expect(page).to have_link('Zuweisen')
        end
      end
      context 'assigned entry' do
        before do
          assignment.update(entry_id: entry.id, recipient_id: editor.id)
          entry.update(user_id: editor.id)
          visit edit_entry_path(entry)
        end
        it 'sees Notification' do
          expect(page).to have_content("In Bearbeitung von #{entry.user.name} zum #{entry.assignment.to_date}")
        end
        it 'sees link Zuweisen Editieren' do
          expect(page).to have_link('Zuweisung Bearbeiten')
        end
        it 'Notification disapears when user visits next template' do
          visit root_path
          expect(page).not_to have_content("In Bearbeitung von #{entry.user.name} zum #{entry.assignment.to_date}")
        end
      end
    end
    context 'as editor' do
      before do
        login_as_user(editor)
        visit edit_entry_path(entry)
      end
      context 'unassigned entry' do
        it 'does not see link Zuweisen' do
          expect(page).not_to have_link('Zuweisen')
        end
      end
    end
  end
end
