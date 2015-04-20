set :css_dir, 'gh-pages/stylesheets'

set :js_dir, 'gh-pages/javascripts'

set :fonts_dir, 'gh-pages/fonts'

set :images_dir, 'images'

activate :livereload

configure :build do
  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  set :google_analytics, true
end
