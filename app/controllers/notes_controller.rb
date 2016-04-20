class NotesController < ApplicationController
  layout "new_version_base"

  def ware
    ware = KcCourses::Ware.find params[:ware_id]

    notes = ware.notes.where(:creator_id => current_user.id).page(params[:page]).per(15)

    data = notes.map do |note|
      DataFormer.new(note)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end

    result = {
      notes: data,
      paginate: DataFormer.paginate_data(notes),
      create_url: notes_path
    }

    render json: result
  end

  def create
    note = NoteMod::Note.new note_params
    note.creator = current_user
    _process_targetable note

    save_model(note) do |_note|
      DataFormer.new(_note)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def show
    note = NoteMod::Note.find params[:id]
    @page_name = "note_show"
    @component_data = DataFormer.new(note)
      .url(:show_url)
      .url(:update_url)
      .url(:delete_url)
      .data
  end

  def update
    note = NoteMod::Note.find params[:id]

    update_model(note, note_params) do |_note|
      DataFormer.new(_note)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    note = NoteMod::Note.find params[:id]
    note.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def _process_targetable(note)
    if params[:ware_id].present?
      note.targetable = KcCourses::Ware.find params[:ware_id]
    end
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
