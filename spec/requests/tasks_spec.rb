require "rails_helper"

RSpec.describe "Tasks", type: :request do
  fixtures :users

  let(:user) { users(:one) }
  let(:project) { Project.create!(title: "Existing Project") }
  let(:task) { project.tasks.create!(title: "Existing Task") }
  let(:valid_params) { { task: { title: "My Task" } } }
  let(:invalid_params) { { task: { title: "" } } }

  describe "GET /projects/:project_id/tasks" do
    context "when signed in" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "returns a successful response" do
        get project_tasks_path(project)
        expect(response).to have_http_status(:success)
      end
    end

    context "when not signed in" do
      it "redirects to the sign in page" do
        get project_tasks_path(project)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/:id" do
    context "when signed in" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "returns a successful response" do
        get project_task_path(project, task)
        expect(response).to have_http_status(:success)
      end
    end

    context "when not signed in" do
      it "redirects to the sign in page" do
        get project_task_path(project, task)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/new" do
    context "when signed in" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "returns a successful response" do
        get new_project_task_path(project)
        expect(response).to have_http_status(:success)
      end
    end

    context "when not signed in" do
      it "redirects to the sign in page" do
        get new_project_task_path(project)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/:id/edit" do
    context "when signed in" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "returns a successful response" do
        get edit_project_task_path(project, task)
        expect(response).to have_http_status(:success)
      end
    end

    context "when not signed in" do
      it "redirects to the sign in page" do
        get edit_project_task_path(project, task)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "POST /projects/:project_id/tasks" do
    context "when signed in with valid params" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "creates a task for the project" do
        expect {
          post project_tasks_path(project), params: valid_params
        }.to change(project.tasks, :count).by(1)
      end

      it "redirects to the new task" do
        post project_tasks_path(project), params: valid_params
        expect(response).to redirect_to(project_task_path(project, Task.last))
      end
    end

    context "when signed in with invalid params" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "does not create a task" do
        expect {
          post project_tasks_path(project), params: invalid_params
        }.not_to change(Task, :count)
      end
    end

    context "when not signed in" do
      it "does not create a task" do
        expect {
          post project_tasks_path(project), params: valid_params
        }.not_to change(Task, :count)
      end

      it "redirects to the sign in page" do
        post project_tasks_path(project), params: valid_params
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id" do
    context "when signed in with valid params" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "updates the task" do
        patch project_task_path(project, task), params: valid_params
        expect(task.reload.title).to eq("My Task")
      end

      it "redirects to the task" do
        patch project_task_path(project, task), params: valid_params
        expect(response).to redirect_to(project_task_path(project, task))
      end
    end

    context "when signed in with invalid params" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "does not update the task" do
        patch project_task_path(project, task), params: invalid_params
        expect(task.reload.title).to eq("Existing Task")
      end
    end

    context "when not signed in" do
      it "does not update the task" do
        patch project_task_path(project, task), params: valid_params
        expect(task.reload.title).to eq("Existing Task")
      end

      it "redirects to the sign in page" do
        patch project_task_path(project, task), params: valid_params
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id" do
    before { task }

    context "when signed in" do
      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "destroys the task" do
        expect {
          delete project_task_path(project, task)
        }.to change(Task, :count).by(-1)
      end

      it "removes the task from the project" do
        delete project_task_path(project, task)
        expect(project.tasks.reload).not_to include(task)
      end

      it "does not destroy the project's other tasks" do
        other_task = project.tasks.create!(title: "Other Task")
        delete project_task_path(project, task)
        expect(project.tasks.reload).to include(other_task)
      end

      it "redirects to the project's task list" do
        delete project_task_path(project, task)
        expect(response).to redirect_to(project_tasks_path(project))
      end
    end

    context "when signed in and the task belongs to a different project" do
      let(:other_project) { Project.create!(title: "Other Project") }

      before do
        post session_path, params: { email_address: user.email_address, password: "password" }
      end

      it "does not destroy the task" do
        expect {
          delete project_task_path(other_project, task)
        }.not_to change(Task, :count)
      end

      it "returns not found" do
        delete project_task_path(other_project, task)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not signed in" do
      it "does not destroy the task" do
        expect {
          delete project_task_path(project, task)
        }.not_to change(Task, :count)
      end

      it "redirects to the sign in page" do
        delete project_task_path(project, task)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
