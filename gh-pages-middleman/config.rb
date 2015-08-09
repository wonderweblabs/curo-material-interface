require 'htmlbeautifier'

set :css_dir, 'gh-pages/assets'

set :js_dir, 'gh-pages/assets'

set :fonts_dir, 'gh-pages/assets'

set :images_dir, 'gh-pages/assets'

activate :livereload

activate :graspi,
  env: environment,
  config_file: File.join(File.dirname(__FILE__), '..', 'graspi/tmp/config.yml')

set :haml, { ugly: true }

configure :build do
  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  set :relative_links, true

  # root
  set :root_path, 'curo-material-interface'

  set :google_analytics, true
end

helpers do
  def code(*args, &block)
    options = args.extract_options!
    options[:col_left] ||= 4
    options[:col_right] ||= 8
    options[:html_options] ||= {}

    html = capture_html(*args, &block)

    classes = ['grid-row']
    classes << options[:html_options][:class] if options[:html_options][:class].present?

    content_tag 'div', class: classes.join(' ') do
      c = []
      c << content_tag('div', html, class: "grid-col-#{options[:col_left]} col-left")
      c << content_tag('div', class: "grid-col-#{options[:col_right]} col-right") do
        html = HtmlBeautifier.beautify(html, tab_stops: 2)
        content_tag 'pre', escape_html(html), class: 'cmi-gh-pages-code'
      end
      c.join('')
    end.html_safe
  end

  def code_2(*args, &block)
    options = args.extract_options!

    options[:col_left] = 6
    options[:col_right] = 6

    code(options, &block)
  end
end