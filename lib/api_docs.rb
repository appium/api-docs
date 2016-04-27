require 'yaml'
require 'escape_utils'


def header
  <<-MARKDOWN
---
title: API Reference
search: false

language_tabs:
  - ruby: Ruby
  - python: Python
  - java: Java
  - javascript: JavaScript
  - php: PHP
  - csharp: C#

toc_footers:
  - <a href="https://github.com/appium/ruby_lib">Ruby bindings</a>
  - <a href="https://github.com/appium/python-client">Python bindings</a>
  - <a href="https://github.com/appium/java-client">Java bindings</a>
  - <a href="https://github.com/admc/wd">JavaScript bindings</a>
  - <a href="https://github.com/appium/php-client">PHP bindings</a>
  - <a href="https://github.com/appium/appium-dotnet-driver">C# bindings</a>
  - <a href="http://appium.io/">Appium home page</a>
---
  MARKDOWN
end

def exit_with message
  puts message
  exit 1
end

# Replace internal github markdown links with a link to the matching Slate anchor
#
# [some text](some-markdown-file.md)
#
# becomes
#
# [some text](#some-markdown-file)
#
# @param markdown [String] markdown to process
# @return [String]
def process_github_links markdown, markdown_file_path
  # links can be multiline so search entire markdown
  # (?<!!) -- negative look behind. don't match if this is an image link. ![]
  markdown.gsub(/(?<!!) \[ ( [^\[]* ) \] \( ( [^)]+ ) \)/mx) do |full|
    result = full

    link_text   = $1
    link_target = $2

    link_target = trim_link link_target
    leading_space = full.match(/^\s*/).to_s
    result = "#{leading_space}[#{link_text}](#{link_target})"

    no_slash = !link_target.include?('/')
    not_link_to_self = !link_target.start_with?('#')

    if link_target && no_slash && not_link_to_self
      ext = File.extname link_target
      no_ext = "No extension on #{full.strip} in #{markdown_file_path.strip}"

      exit_with no_ext if invalid_ext?(ext, link_target)

      # If a link has a has, use that. Otherwise link to the start of the file.
      ext, hash = ext.split '#'
      if ext == '.md'
        result = "#{leading_space}[#{link_text}](##{hash || link_target})"
      elsif invalid_ext?(ext, link_target)
        exit_with no_ext
      end
    end

    result
  end
end

def invalid_ext? ext, link_target
  ext.empty? && ! link_target.end_with?('/')
end

# process docs/en/filename.md#testing links
# handle relative links [getting started](../../README.md)
# handle absolute sample code links [example](/sample-code/java/sample.java)
def trim_link link_target
  link_target = link_target.strip if link_target

  return "https://github.com/appium/appium/tree/master#{link_target}" if link_target.start_with?('/sample-code/')
  return link_target if link_target.end_with?('/')
  # trim doc and relative
  trim = link_target.start_with?('docs/') || link_target.start_with?('../')
  trim ? File.basename(link_target) : link_target
end

def order_list(order, files, ignore_list)

  extra_files   = []
  ordered_files = []
  files.each do |file|
    index = order.index File.basename file

    if index
      ordered_files[index] = file
    elsif ignore_list.index File.basename file
      #ignore file/folder
    else
      extra_files << file
    end
  end

  ordered_files.compact! # remove nils

  # return ordered first with extra tacked on the end.
  ordered_files + extra_files
end

def pwd
  File.expand_path Dir.pwd
end

# Glob for files. Directories are skipped
#
# @param glob [String] glob to Dir.glob
#
# @return [Array<String>] the globbed files
def file_glob glob
  files = []

  Dir.glob(glob) do |markdown_file|
    next if File.directory? markdown_file
    files << File.expand_path(markdown_file)
  end

  files
end

def validate_dir dir
  unless File.exist?(dir) && File.readable?(dir) &&
    File.directory?(dir)
    raise "#{dir} is not an existing readable directory"
  end
  dir
end

def markdown opts={}
  folder_to_glob = validate_dir opts[:glob]
  output_folder = validate_dir opts[:output]
  directories = Dir.entries(opts[:glob]).select {|folder| File.directory? File.join(opts[:glob],folder) and !(folder =='.' || folder == '..') }
  #Making it backward compatible if no directories are present (older versions of appium docs does not have directory structure).
  if directories.length === 0
    markdown_old opts
  else
    data = ''
    yaml_settings_data = YAML.load_file "api-docs.yml"
    folder_map = yaml_settings_data["folder-map"]
    ignore_list = yaml_settings_data["ignore"]
    directories = order_list(yaml_settings_data["folder-order"], directories, ignore_list)

    directories.each do |directory_name|

      subdirectory = File.join(folder_to_glob,directory_name);
      files = file_glob File.expand_path(File.join(subdirectory, '**', '*.md'))
      files = order_list(folder_map[directory_name]["file-order"], files, ignore_list)
      data += "# #{folder_map[directory_name]["label"]}\n\n"
      files.each do |markdown_file|
        # anchor must be placed after the first h1 otherwise the css will break
        # .content h1:first-child is used in screen.css
        filename_anchor = %Q(<span id="#{File.basename(markdown_file)}"></span>)
        markdown        = File.read(markdown_file).strip

        lines    = markdown.split "\n"
        markdown = ''

        matched = false
        lines.each do |line|

          # insert anchor after matching the first h2
          if !matched && line.strip.match(/^##[^##]/)
            # ' # # hi'.split('#', 2)
            # => [" ", " # hi"]
            # must strip or '-' will be prefixed to the id by Slate
            after_first_hash = line.split('##', 2).last.strip

            # <h1 id="credits"><span id="credits.md"></span>Credits</h1>
            markdown         += "## #{filename_anchor}#{after_first_hash}\n\n"
            matched          = true
          else
            markdown += line + "\n"
          end
        end

        markdown = process_github_links markdown, markdown_file

        data += "\n\n" + markdown + "\n\n"
      end
    end

    data.gsub! '<expand_table>', '<p class="expand_table"></p>'
    data.gsub! /]\s*\(\/docs\/en\/.*\//, '](#'
    data.gsub!('](/docs/en/)', '](#)')
    #Replacing broken links.
    data.gsub!('https://dvcs.w3.org/hg/webdriver/raw-file/tip/webdriver-spec.html','https://w3c.github.io/webdriver/webdriver-spec.html')
    data.gsub!('https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/_index.html','https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/')
    # ```center code_block ``` to <p class=\"centercode\"><code>code_block</code></p>
    # to center align code blocks which are marked as center in markdown
    data.gsub!(/^([ \t]*)``` ?center?\r?\n(.+?)\r?\n\1(```)[ \t]*\r?$/m) do
      m_indent = $1
      m_code   = $2
      m_code   = EscapeUtils.escape_html(m_code)

      "#{m_indent}<p class=\"centercode\"><code>#{m_code}</code></p>"
    end
    index_file = File.expand_path(File.join(output_folder, 'index.md'))

    File.open(index_file, 'w') do |f|
      f.write header + data
    end
  end

end

def markdown_old opts={}

  folder_to_glob = validate_dir opts[:glob]
  output_folder = validate_dir opts[:output]
  data = ''
  yaml_settings_data = YAML.load_file "api-docs.yml"
  files = file_glob File.expand_path(File.join(folder_to_glob, '**', '*.md'))
  files = order_list(yaml_settings_data["file-order-older-versions"], files, yaml_settings_data["ignore-files-older-versions"])
  files.each do |markdown_file|
    # anchor must be placed after the first h1 otherwise the css will break
    # .content h1:first-child is used in screen.css
    filename_anchor = %Q(<span id="#{File.basename(markdown_file)}"></span>)
    markdown        = File.read(markdown_file).strip

    lines    = markdown.split "\n"
    markdown = ''

    matched = false
    lines.each do |line|

      # insert anchor after matching the first h1
      if !matched && line.strip.match(/^#[^#]/)
        # ' # # hi'.split('#', 2)
        # => [" ", " # hi"]
        # must strip or '-' will be prefixed to the id by Slate
        after_first_hash = line.split('#', 2).last.strip

        # <h1 id="credits"><span id="credits.md"></span>Credits</h1>
        markdown         += "# #{filename_anchor}#{after_first_hash}\n\n"
        matched          = true
      else
        markdown += line + "\n"
      end
    end

    markdown = process_github_links markdown, markdown_file

    data += "\n\n" + markdown + "\n\n"
  end

  data.gsub! '<expand_table>', '<p class="expand_table"></p>'
  data.gsub!('https://dvcs.w3.org/hg/webdriver/raw-file/tip/webdriver-spec.html','https://w3c.github.io/webdriver/webdriver-spec.html')
  data.gsub!('https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/_index.html','https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/')

  index_file = File.expand_path(File.join(output_folder, 'index.md'))

  File.open(index_file, 'w') do |f|
    f.write header + data
  end
end
