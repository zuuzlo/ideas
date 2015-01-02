class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_notable,  only: [:new, :create, :edit, :update, :destroy]
  before_filter :find_note, only: [:edit, :update, :destroy]
=begin
  def new
    @note = Note.new
    @note.user_id = current_user.id
  end
=end
  def create
    @note = @notable.notes.build(note_params)
    respond_to do |format|
      if @note.save
        flash[:success] = "Created a new note." 
        format.html { redirect_to @notable }
        format.js   { render action: 'show', location: @notable }
      else
        flash[:danger] = "Failed to create note." 
        format.html { render location: polymorphic_path(@notable) }
        format.js   { render json: @note.errors, status: :unprocessable_entity }
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
        format.html { render location: polymorphic_path(@notable) }
        format.json { render json: @note.errors, status: :unprocessable_entity }
        format.js   { render json: @note.errors, status: :unprocessable_entity }
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

  private

  def find_note
    @note = @notable.notes.friendly.find(params[:id])
  end

  def load_notable

    if params[:category_id]
      @notable = Category.friendly.find(params[:category_id])
    #elsif params[:photo_id]
    #  @commentable = Photo.find(params[:photo_id])
    #elsif params[:event_id]
    #  @commentable = Event.find(params[:event_id])
    end
  end

  def note_params
    params.require(:note).permit(:id, :title, :text, :user_id, :slug, :category_id)
  end
end