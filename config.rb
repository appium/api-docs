set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :fonts_dir, 'fonts'

set :markdown_engine, :redcarpet

set :markdown, :fenced_code_blocks => true, :smartypants => true, :disable_indented_code_blocks => true, :prettify => true, :tables => true, :with_toc_data => true, :no_intra_emphasis => true

# Activate the syntax highlighter
activate :syntax

# This is needed for Github pages, since they're hosted on a subdomain
activate :relative_assets
set :relative_links, true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# Requires patched middleman
#
# https://github.com/middleman/middleman/pull/1278
# https://github.com/middleman/middleman/issues/1277
after_render do |content, path, locs, template_class|
  # restore character entities such as &amp;#96;
  content ||= ''
  content.gsub! '&amp;', '&'

=begin

Input:

<ruby>

ruby paragraph

</ruby>

<java>

java pragraph

</java>

Transformed:

&lt;ruby>

ruby paragraph

&lt;&#47;ruby>

&lt;java>

java paragraph

&lt;&#47;java>

Html:

<span class="desc ruby">

<p>ruby paragraph</p>

</span>

<span class="desc java">

<p>java paragraph</p>

</span>
=end

  # replacement, [targets]
  map = [
    ['<span class="desc ruby">', ['<p>&lt;ruby&gt;</p>']], # <ruby>
    ['<span class="desc java">', ['<p>&lt;java&gt;</p>']], # <java>
    ['</span>', ['<p>&lt;&#47;ruby&gt;</p>', # </ruby>, </java> => </span>
                 '<p>&lt;&#47;java&gt;</p>']],
  ]

  map.each do |replacement, targets|
    targets.each do |target|
      content.gsub! target, replacement
    end
  end

  content
end