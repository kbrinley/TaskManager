# <summary>
# Controller code for Goals. Allows display, creation, deletion, and the completion of Goals
# </summary>
class GoalsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:index]
  before_filter :goal_exists, :only => [:update, :complete, :destroy]
  before_filter :correct_user_by_goalid, :only => [:update, :complete, :destroy]
  before_filter :goal_not_completed, :only => [:update, :complete, :destroy]
  
  # <summary>
  # 
  # </summary>
  def index
    @title = "My Goals"
    @goaltypes = Goaltype.all
    @goals = @user.goals
    @dailygoals = @user.goals.find(:all, :conditions => {:goaltype_id => 1, :datecompleted => nil})
    @weeklygoals = @user.goals.find(:all, :conditions => {:goaltype_id => 2, :datecompleted => nil})
    @monthlygoals = @user.goals.find(:all, :conditions => {:goaltype_id => 3, :datecompleted => nil})
    @goal = @user.goals.new
  end

  # <summary>
  # Creates a new Task and returns the user to the index page.
  # </summary>
  def create
    @goal = current_user.goals.build(params[:goal])
    if @goal.save
      flash[:success] = "Goal saved successfully"
      #redirect_to :action => "index", :id => current_user.id
      render :partial => "goal", :object => @goal
    else
      #redirect_to :action => "index", :id => current_user.id
      render :text => @goal.errors.full_messages, :status => 403
    end
  end
  
  # <summary>
  # Edits the task and returns the user to the index page.
  # </summary>
  def update
    @goal = Goal.find(params[:id])
    if (@goal.update_attributes(params[:edit_goal]))
      flash[:success] = "Goal Updated!"
      #redirect_to :action => "index", :id => current_user.id
      render :partial => "goal", :object => @goal
    else
      #redirect_to :action => "index", :id => current_user.id
      render :text => @goal.errors.full_messages, :status => 403
    end
  end
  
  # <summary>
  # Destroys the Goal and returns the user to the index page.
  # </summary>
  def destroy
    Goal.find(params[:id]).destroy
    flash[:success] = "Goal Removed"
    redirect_to :action => "index", :id => current_user.id
  end
  
  # <summary>
  # Sets the completed date of the Goal. Its the Indexes (and the Reports) responsibility
  # to know that the Goal is completed by the inclusion of the date.
  # </summary>
  def complete
    @completedgoal = Goal.find(params[:id])
    if (@completedgoal.update_attributes(:datecompleted => Time.now))
      flash[:success] = "Goal Completed"
      redirect_to :action => "index", :id => current_user.id
    else
      flash[:failure] = "Error completing goal"
      redirect_to :action => "index", :id => current_user.id
    end
  end
  
  private
  def correct_user_by_goalid
    @user = @goal.user
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def goal_exists
    @goal = Goal.find(params[:id])
    #@user = @goal.user
    redirect_to(root_path) unless @goal != nil
  end
  
  def goal_not_completed
    redirect_to(root_path) unless @goal.datecompleted.nil?
  end
end