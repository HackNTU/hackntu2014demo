class ProjectsController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:new, :edit, :create, :update, :destroy]

  before_action :set_project, only: [:show, :edit, :update, :destroy, :vote]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(:user => current_user).all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    redirect_to Project, alert: "不要亂看！" if @project.user != current_user
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    if Project.where(:user => current_user).count >= 1
      redirect_to Project, alert: "你已經有專案了喲"
      return
    end
    
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    redirect_to root_url, notice: "Ooos" if @project.user != current_user
    
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if @project.user == current_user    
      @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to action: 'index' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote

    direction = params[:direction]

    # Make sure we've specified a direction
    raise "No direction parameter specified to #vote action." unless direction

    # Make sure the direction is valid
    unless ["like", "bad"].member? direction
      raise "Direction '#{direction}' is not a valid direction for vote method."
    end

    @project.vote voter: current_user, vote: direction

    redirect_to index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :user_id)
    end
end
