require 'rails_helper'

RSpec.describe Project, type: :request do
fixtures :users

let(:user) { users(:one) }

describe "GET /Projects" do
    context "when signed in" do
        before do
            post session_path, params: { email_address: user.email_address, password: "password" }
        end

        it "returns a sucessful response" do
            get "/projects"
            expect(response).to have_http_status(:success)
        end
    end

    context "when not signed in" do
        it "redirects to the sign in page" do
            get "/projects"
            expect(response).to redirect_to(new_session_path)
        end
    end
end

describe "POST /projects" do
    let(:valid_params) { { project: { title: "My Project" } } }

    before do
        post session_path, params: { email_address: user.email_address, password: "password" }
    end

    it "creates a project and redirects to it" do
        expect {
            post projects_path, params: valid_params
        }.to change(Project, :count).by(1)

        expect(response).to redirect_to(project_path(Project.last))
    end
end
end
