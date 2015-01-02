class NotesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js, :html
  before_action :load_notable,  only: [:new, :create, :edit, :update, :destroy ]
  before_action :find_note, only: [:edit, :update, :destroy ]

  def new
    @note = Note.new
    @note.user_id = current_user.id
  end

  def create
    @note = @notable.notes.build(note_params)
    respond_to do |format|
      if @note.save
        flash[:success] = "Created a new note." 
        format.html { redirect_to @notable }
        format.js   { render action: 'create', location: @notable }
      else
        flash[:danger] = "Failed to create note." 
        format.html { render nothing: true }
        format.js   { render action: 'edit' }
      end
    end
  end

  def edit

  end

  def update

    respond_to do |format|
      if @note.update(note_params)
        flash[:success] = "Successfully updated note." 
        format.html { redirect_to @notable }
        format.js   { render action: 'update', location: @notable }
      else
        flash[:danger] = "Failed update note." 
        format.html { render nothing: true }
        format.js   { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @note.destroy
        flash[:success] = "Note removed."
        format.html { redirect_to @notable }
        format.js { render action: 'delete', location: @notable }
      else
        flash[:danger] = "Failed to remove note."
        format.html { render location: polymorphic_path(@notable) }
      end
    end
  end

  def show
    @note = Note.friendly.find(params[:id])
    @notable = Note.friendly.find(params[:id])
  end

  private

    def find_note
      @note = @notable.notes.friendly.find(params[:id])
    end

    def load_notable

      if params[:category_id]
        @notable = Category.friendly.find(params[:category_id])
      elsif params[:note_id]
        @notable = Note.friendly.find(params[:note_id])
      elsif params[:idea_id]
        @notable = Idea.friendly.find(params[:idea_id])
      end
    end

    def note_params
      params.require(:note).permit(:id, :title, :text, :user_id, :slug, :category_id)
    end
end