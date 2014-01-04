class EntriesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
     respond_with reset()
  end

  def show
    respond_with Entry.find(params[:id])
  end

  def create
    respond_with Entry.create(entry_params)
  end

  def update
    entry = Entry.find(params[:id])
    respond_with entry.update(entry_params)
  end

  def destroy
    respond_with Entry.destroy(params[:id])
  end

  private

  def reset
    entries = Entry.all
    entries.update_all(:winner => false)
    return entries
  end

  def entry_params
    params.require(:entry).permit(:name, :winner)
  end
end
