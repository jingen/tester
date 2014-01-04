class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  def index
    @issues = Issue.all
  end

  def show
  end

  def new
    @issue = Issue.new
  end

  def edit
  end

  def create
    @issue = Issue.new(issue_params)
    Project.first.issues << @issue
    respond_to do |format|
      if @issue.save
        flash[:notice] = "Issue was successfully created."
        format.html {redirect_to @issue}
        format.json {render 'show', status: :created, location: @issue}
      else
        format.html {render 'new'}
        format.json {render json: @issue.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.'}
        format.json { head :no_content}
      else
        format.html {render 'edit'}
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end


  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :no_followers, :image)
  end
end
