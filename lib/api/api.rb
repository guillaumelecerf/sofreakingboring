Dir["#{Rails.root}/lib/api/*.rb"].each {|file| require file}

module API
  class API < Grape::API
    version 'v1', using: :path

    rescue_from ActiveRecord::RecordNotFound do
      rack_response({'message' => '404 Not found'}.to_json, 404)
    end

    rescue_from :all do |exception|
      trace = exception.backtrace

      message = "\n#{exception.class} (#{exception.message}):\n"
      message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
      message << "  " << trace.join("\n  ")

      API.logger.add Logger::FATAL, message
      rack_response({'message' => '500 Internal Server Error'}, 500)
    end

    format :json
    content_type :txt, "text/plain"

    helpers APIHelpers

    mount Users
    mount Projects
    mount ProjectMembers
    mount ProjectSnapshots
    mount Tasks
    mount WorkLogs
    mount Timesheets
  end
end
