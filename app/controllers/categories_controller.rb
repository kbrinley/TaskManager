# <summary>
class CategoriesController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:index]
  before_filter :correct_user_by_categoryid, :only => [:update]
  before_filter :premium_user
  
  def index
    @title = "My Categories"
    @categories = @current_user.category.find(:all, :conditions => ["listorder != 0 AND listorder != 5"], :order => "listorder")
  end
  
  def update
    if (@category.update_attributes(params[:edit_category]))
      flash[:success] = "Category Updated!"
      redirect_to :action => "index", :id => current_user.id
    else
      redirect_to :action => "index", :id => current_user.id
    end
  end
  
  private
  def correct_user_by_categoryid
    @category = Category.find(params[:id])
    if (current_user?(@category.user))
      @user = @category.user
    else
      redirect_to(root_path)
    end
  end
  
end