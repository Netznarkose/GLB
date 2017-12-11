require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :assigned_from_user => 1,
      :assigned_to_user => "",
      :assigned_entry => 1
    ))
  end

  xit "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do

      assert_select "input#task_assigned_from_user[name=?]", "task[assigned_from_user]"

      assert_select "input#task_assigned_to_user[name=?]", "task[assigned_to_user]"

      assert_select "input#task_assigned_entry[name=?]", "task[assigned_entry]"
    end
  end
end
