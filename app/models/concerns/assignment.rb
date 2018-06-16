module Assignment
  def destroy_related_assignment
    assignment.destroy if assignment.present?
  end

  def assignment
    Assignment.find_by(entry_id: id)
  end
end
