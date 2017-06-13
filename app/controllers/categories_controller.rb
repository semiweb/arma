class CategoriesController < ApplicationController
  before_action :set_application
  before_action :set_category, only: [:destroy,:update]

  def create
    @application.categories.create!(name: params[:name])
    redirect_to edit_application_path(@application)
  end

  def destroy
    @category.destroy!
    respond_to do |format|
      format.js { render 'categories/destroy'}
      format.html { return redirect_to edit_application_path(@application) }
    end
  end

  def update
    @category.update_attributes(name:params[:name])

    respond_to do |format|
      format.js { render 'categories/update'}
      format.html { return redirect_to edit_application_path(@application) }
    end
  end

  private
  def set_application
    @application = Application.find(params[:application_id])
  end

  def set_category
    @category = @application.categories.find(params[:id])
  end

end
