module NotesHelper
  def notable_link(type, id)
    notable_path = type.constantize.friendly.find(id)
    link_to "Link to Parent", notable_path
  end
end