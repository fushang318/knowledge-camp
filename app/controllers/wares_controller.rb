class WaresController < ApplicationController
  def read
    @ware = KcCourses::Ware.find params[:id]
    @ware.set_read_percent_by_user(current_user, ware_params[:percent].to_i)
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def ware_params
    params.require(:ware).permit(:id, :percent)
  end
end
