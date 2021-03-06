module API
  # Projects API
  class Projects < Grape::API
    before { authenticate! }

    resource :projects do

      # Get a projects list for authenticated user
      #
      # Example Request:
      #   GET /projects
      get do
        @projects = paginate current_user.projects
        present @projects, with: Entities::Project
      end

      # Get a single project
      #
      # Parameters:
      #   id (required) - The ID of a project
      # Example Request:
      #   GET /projects/:id
      get ":id" do
        authorize! :read_project, user_project        
        present user_project, with: Entities::Project, user: current_user
      end
    end
  end
end