class TasksController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:index]
  before_filter :task_exists, :only => [:update, :destroy, :delete]
  before_filter :correct_user_by_taskid, :only => [:update, :destroy, :delete]
  before_filter :task_not_completed, :only => [:update, :destroy, :delete]
  
  # Main Task page. From here, the user can create, edit, and destroy Tasks.
  def index
    completedcategoryid = @user.category.find(:all, :conditions => [
      "listorder = 0"
    ])[0].id
    @tasks = @user.tasks
    @active_task_count = @user.tasks.find(:all, :conditions =>
      ["category_id != '#{completedcategoryid}'"]).count
    @edittask = @user.tasks[0]
    @task = @user.tasks.new
    @categories = @user.category.find(:all, :conditions =>[
      "listorder != 0"
    ])
    #@itemcolor = @user.itemcolors.find(:all)
    @title = "My Tasks"
  end

  # Creates a new Task and returns the user to the index page.
  def create
    @task = current_user.tasks.build(params[:task])
    if @task.category_id = 0
      @task.category_id = current_user.category.find(:all, 
        :order => "listorder asc",
        :conditions => [ "listorder != 0"])[0].id
    end
    if @task.save
      #@task.taskhistories.create!(:category_id => @task.category_id)
      #@task.taskhistories.save_without_transactions
      #flash[:success] = "Tasks saved successfully"
      render :partial => "task", :object => @task
    else
      #flash[:error] = @task.errors.full_messages
      render :text => @task.errors.full_messages, :status => 403
    end
  end

  # Edits the task and returns the user to the index page.
  def update
    @task = Task.find(params[:id])
    @oldcategory = @task.category_id
    if (@task.update_attributes(params[:edit_task]))
      if (@oldcategory != @task.category_id)
        @task.taskhistories.create!(:category_id => @task.category_id)
      end
      #flash[:success] = "Task Updated!"
      #redirect_to :action => "index", :id => current_user.id
      render :partial => "task", :object => @task
    else
      #flash[:error] = @task.errors.full_messages
      #redirect_to :action => "index", :id => current_user.id, :status => 451
      render :text => @task.errors.full_messages, :status => 403
    end
  end
  
  # Destroys the task and returns the user to the index page.
  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "Task Deleted"
    redirect_to :action => "index", :id => current_user.id
  end
  
  def complete
    @complete_category = current_user.category.find(:all, :conditions => [
      "label = 'Completed'"
    ])
    @completedtask = Task.find(params[:id])
    if (@completedtask.update_attributes(:category_id => @complete_category[0].id))
      @completedtask.taskhistories.create!(:category_id => @completedtask.category_id)
      flash[:success] = "Task Completed"
      redirect_to :action => "index", :id => current_user.id
    else
      flash[:failure] = "Error completing task"
      redirect_to :action => "index", :id => current_user.id
    end
  end
  
  private
  def task_exists
    @thetask = Task.find(params[:id])
    redirect_to(root_path) unless @thetask != nil
  end
  
  def correct_user_by_taskid
    @user = @thetask.user
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def task_not_completed
    completedcategoryid = @user.category.find(:all, :conditions => [
      "listorder = 0"
    ])[0].id
    redirect_to(root_path) unless @thetask.category_id != completedcategoryid
  end
end
