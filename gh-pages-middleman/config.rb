set :css_dir, 'curo-material-interface/stylesheets'

set :js_dir, 'curo-material-interface/javascripts'

set :fonts_dir, 'curo-material-interface/fonts'

set :images_dir, 'images'

activate :livereload

configure :build do
  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  set :google_analytics, true
end
