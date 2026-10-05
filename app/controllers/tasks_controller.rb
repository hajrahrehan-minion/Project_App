class TasksController < ApplicationController

def index
   @project = Project.find(params[:project_id])
   @tasks = @project.tasks
end

def show 
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
end

def create 
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    if @task.save
        redirect_to project_task_path(@project, @task), notice: 'Task was successfully created.'
    else
        render :new
    end
end

def new 
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build
end

def edit
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
end

def update  
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    if @task.update(task_params)
        redirect_to project_task_path(@project, @task), notice: 'Task was successfully updated.'
    else
        render :edit
    end
end

def destroy
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    @task.destroy
    redirect_to project_tasks_path(@project), notice: 'Task was successfully destroyed.'
end

private
def task_params
    params.require(:task).permit(:title)
end 
end