require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do
    assign(:tasks, [
      Task.create!(
        :assigned_from_user => 2,
        :assigned_to_user => "",
        :assigned_entry => 3
      ),
      Task.create!(
        :assigned_from_user => 2,
        :assigned_to_user => "",
        :assigned_entry => 3
      )
    ])
  end

  it "renders a list of tasks" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
