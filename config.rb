Encoding.default_external = 'UTF-8'

require 'coffee-filter'

activate :i18n, :mount_at_root => :en

set :relative_links, true
set :build_dir, 'public'

["*slides*", "*form*"].each do |page|
  page "#{page}", :layout => false
end

helpers do
  def localized_path(path, extension = 'html')
    path = I18n.t "paths.#{path}"
    "#{path}.#{extension}"
  end

  def t(string)
    I18n.t(string)
  end
end

configure :build do
  activate :relative_assets
  # activate :minify_css
  # activate :minify_javascript
end
