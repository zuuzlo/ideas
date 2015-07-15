class IdeaLinksController < ApplicationController
  before_action :authenticate_user!
  respond_to :js, :html
  before_action :load_idea_linkable, only: [:destroy, :new, :create, :edit, :update]
  before_action :set_idea_link, only: [:destroy, :edit, :update]

  def new
    @idea_link = IdeaLink.new
    @idea_link.user_id = current_user.id
  end

  def create
    @idea_link = @idea_linkable.idea_links.build(idea_link_params)

    if @idea_link.save
      flash[:success] = "You created a new link."
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def update

    if @idea_link.update(idea_link_params)
      flash[:success] = "Successfully updated link."
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def destroy
    if @idea_link.destroy
      flash[:success] = "Link removed."
    else
      flash[:danger] = "Failed to remove link."
    end  
  end

  private
    def set_idea_link
      @idea_link = IdeaLink.friendly.find(params[:id])
    end

    def load_idea_linkable
      if params[:idea_id]
        @idea_linkable = Idea.friendly.find(params[:idea_id])
      elsif params[:task_id]
        @idea_linkable = Task.friendly.find(params[:task_id])
      elsif params[:note_id]
        @idea_linkable = Note.friendly.find(params[:note_id])
      end
    end

    def idea_link_params
      params.require(:idea_link).permit(:id, :name, :link_url, :user_id, :slug, :idea_id)
    end

end
