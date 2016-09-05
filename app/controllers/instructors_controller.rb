class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  before_action :confirm_admin_permissions, except: [:create, :new, :show, :edit]

  def verify
    instructor = Instructor.find(params[:id])
    instructor.status = 'Active'
    instructor.save
    redirect_to instructors_path, notice: "Instructor has been verified"
  end

  def revoke
    instructor = Instructor.find(params[:id])
    instructor.status = "Revoked"
    instructor.save
    redirect_to instructors_path, notice: "Instructor privileges have been revoked"
  end

  # GET /instructors
  # GET /instructors.json
  def index
    @instructors = Instructor.all.sort {|a,b| a.last_name <=> b.last_name}
  end

  # GET /instructors/1
  # GET /instructors/1.json
  def show
  end

  # GET /instructors/new
  def new
    if current_user.instructor
      @instructor = current_user.instructor
      render 'edit'
      else
      @instructor = Instructor.new
    end
  end

  # GET /instructors/1/edit
  def edit
  end

  # POST /instructors
  # POST /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)
    @instructor.user_id = current_user.id
    @instructor.status = "new applicant"

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to root_path, notice: 'Your instructor application was successfully submitted, you will be contacted shortly. You may also reach out with questions to info@surfschoolers.com' }
        format.json { render action: 'show', status: :created, location: @instructor }
      else
        format.html { render action: 'new' }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1
  # PATCH/PUT /instructors/1.json
  def update
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to root_path, notice: 'Your instructor application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1
  # DELETE /instructors/1.json
  def destroy
    @instructor.destroy
    respond_to do |format|
      format.html { redirect_to instructors_url }
      format.json { head :no_content }
    end
  end

  private
    def confirm_admin_permissions
      return if current_user.email == 'brian@skischool.co' || current_user.email == 'bbensch@gmail.com'
      redirect_to root_path, notice: 'You do not have permission to view that page.'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :username, :preferred_locations, :certification, :phone_number, :sport, :bio, :intro, :status, location_ids:[])
    end
end
