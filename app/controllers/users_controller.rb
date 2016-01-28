class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show, :index, :destroy, :makeadmin, :makepremium, :removepremium] 
  before_filter :correct_user_or_admin_user, :only => [:show, :edit, :update]
  before_filter :admin_user, :only => [:index, :destroy, :makeadmin, :makepremium, :removepremium, :clearresetcode, :setexpirationdate, :increaseexpirationdate]
  
  
  def show
    @user = User.find(params[:id])
    @title = "Dashboard"
    @other = {:betacode => ""}
    @inprogress_category = @user.category.find(:all, :conditions => [
      "listorder = 2"
    ])[0]
    #@activetasks = @user.tasks.find(:all, :conditions => ["category_id != '#{inprogress_category_id}'"]) #Need to find better way to grab In Progress category
    @dailygoals = @user.goals.find(:all, :conditions => {:goaltype_id => 1, :datecompleted => nil})
    @goaltypes = Goaltype.find(:all, :conditions => {:id => 1})
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def edit
    @title = "Edit User Information"
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if (@user.update_attributes(params[:user]))
      flash[:success] = "User Settings updated"
      redirect_to :action => "show", :id => current_user.id
    else
      flash[:error] = @user.errors.full_messages
      redirect_to :action => "edit", :id => current_user.id
    end
  end
  
  def create
    #if (params[:other] == "SandBridgeSoftware46038")
    @user = User.new(params[:user])
    if @user.save
      #Premium account and Account expiration cannot be set within the after_create function (perhaps move to before create?)
      #@user.toggle!(:premiumaccount)
      #@user.accountexpiration = Time.now + 120.days
      if @user.save_without_validation
        # Part of sessions controller
        #@user.sign_in
        flash[:success] = "Welcome to Kanban For Developers"
        #redirect_to ???
        sign_in @user
        render 'show'
      else
        flash[:error] = "An error occurred while creating your account. Please try again later or contact us at support@kanbanfordevelopers.com"
        @title = "Sign up"
        render 'new'
        # Do something with the email address???
      end
    else
      @title = "Sign up"
      render 'new'
    end
    #else
    #  flash[:error] = "Beta is only open to select users"
    #  @title = "Sign up"
    #  redirect_to root_path
      # Do something with the email address???
    #end
  end
  
  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User removed"
    redirect_to users_path
  end
  
  def makeadmin
    u = User.find(params[:id])
    u.toggle!(:adminaccount)
    redirect_to users_path
  end
  
  def makepremium
    u = User.find(params[:id])
    u.toggle!(:premiumaccount)
    redirect_to users_path
  end
  
  def removepremium
    u = User.find(params[:id])
    u.toggle!(:premiumaccount)
    redirect_to users_path
  end
  
  def setexpirationdate
    u = User.find(params[:id])
    u.accountexpiration = params[:user][:accountexpiration]
    if u.save_without_validation
    #if (u.update_attributes(params[:user]))
      flash[:success] = "User's Expiration Date updated"
      redirect_to users_path
    else
      flash[:error] = "An error occurred updating the User's expiration date"
      redirect_to users_path
    end  
  end
  
  def increaseexpirationdate
    u = User.find(params[:id])
    numberOfMonths = Integer(params[:months])
    if (numberOfMonths != 12)
      u.accountexpiration = u.accountexpiration + numberOfMonths.months
    else
      u.accountexpiration = u.accountexpiration + 1.years
    end
    if u.save_without_validation
      flash[:success] = "User's Expiration Date updated"
      redirect_to users_path
    else
      flash[:error] = "An error occurred updating the User's expiration date"
    end
  end
  
  def forgot
    if request.post?
      @resetuser = User.find_by_email(params[:user][:email])
      #flash[:notice] = params[:user][:email]
      if @resetuser
        #if (@resetuser.update_attributes(:reset_code => @resetuser.generate_reset_code))
        @resetuser.create_reset_code!
        #flash[:notice] = @resetuser.reset_code
        #end
        link = "http://www.kanbanfordevelopers.com/reset/" + @resetuser.reset_code
        #body = "A request has been received to reset the password on your Kanban For Developers account.\n\rTo reset your password, please follow this link:" + link + "\n\r\n\rThank you."
        Emailer.deliver_forgot_password(@resetuser.email, "Password Reset Request", link)
        return if request.xhr?
        flash[:notice] = "Reset code sent to #{@resetuser.email}"
      else
        flash[:notice] = "#{params[:user][:email]} does not exist in system"
      end
      redirect_to '/'
    end
  end
  
  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    #    if !@user
    #flash[:error] = "Reset password token invalid, please contact support."
    #      flash[:notice] = "Reset_code:" + params[:reset_code]
    #      redirect_to('/')
    #      return
    #    end
    if request.post?
      @user = User.find_by_reset_code(params[:user][:reset_code])
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        #self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_to '/'
      else
        render :action => :reset
      end
    end
  end
  
  def clearresetcode
    @user = User.find(params[:id])
    @user.delete_reset_code
    redirect_to users_path
  end
  
  private
  def correct_user_or_admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless (current_user?(@user) || current_user.adminaccount? || current_user.id == 1)
  end
  
  def admin_user
    redirect_to(root_path) unless (current_user.adminaccount? || current_user.id == 1)
  end
end
