# Be sure to restart your server when you modify this file.
#
# Allows the Vite dev server (and any origins listed in CORS_ORIGINS) to POST to /graphql.
# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("CORS_ORIGINS", "http://localhost:5173").split(",")

    resource "/graphql",
      headers: :any,
      methods: [:post, :options]
  end
end
