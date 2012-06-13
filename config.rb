Encoding.default_external = 'UTF-8'

require 'coffee-filter'

set :relative_links, true

###
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page "form.php", :layout => false
page "it/form.php", :layout => false

page "form-booking-success.html", :layout => false
page "it/form-booking-success.html", :layout => false

page "form-booking-warning.php", :layout => false
page "it/form-booking-warning.php", :layout => false

page "slides.html", :layout => false
page "it/slides.html", :layout => false

# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

# ['index', 'villas', 'activities', 'credits', 'privacy'].each do |page|
#   page "#{page}.html", :proxy => "/localizable/standard.html" do
#     @page = page
#   end
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  def localized_path(path, extension = 'html')
    path = I18n.t "paths.#{path}"
    "#{path}.#{extension}"
  end
end

# set :css_dir, 'stylesheets'
# set :js_dir, 'javascripts'
# set :images_dir, 'images'

activate :i18n, :mount_at_root => :en

# set :build_dir, 'public'
# set :http_prefix, 'preview'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
end
