module LoadChildren
  extend ActiveSupport::Concern

  def load_children(parent)
    @notes = parent.notes
    @tasks = parent.tasks
    @idea_links = parent.idea_links

    @note = Note.new
    @task = Task.new
    @idea_link = IdeaLink.new
  end
end