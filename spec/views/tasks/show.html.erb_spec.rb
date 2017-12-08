require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :assigned_from_user => 2,
      :assigned_to_user => "",
      :assigned_entry => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(/3/)
  end
end
