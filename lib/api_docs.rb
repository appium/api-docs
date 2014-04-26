def header
  <<-MARKDOWN
---
title: API Reference
search: true

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
  markdown.gsub(/(?<!!) \[ ( [^\[]* ) \] \( ( [^)\/]+ ) \)/mx) do |full|
    result = full

    link_text   = $1
    link_target = $2

    if link_target && !link_target.include?('/')
      ext = File.extname link_target
      no_ext = "No extension on #{full.strip} in #{markdown_file_path.strip}"

      exit_with no_ext if ext.empty?

      # If a link has a has, use that. Otherwise link to the start of the file.
      ext, hash = ext.split '#'
      if ext == '.md'
        result = " [#{link_text}](##{hash || link_target.strip})"
      elsif ext.empty?
        exit_with no_ext
      end
    end

    result
  end
end

def order_files files
  order = %w(
intro.md

platform-support.md
real-devices.md

running-on-osx.md
running-on-windows.md
running-on-linux.md

running-tests.md

android-hax-emulator.md
android_coverage.md

server-args.md
caps.md

finding-elements.md
gestures.md
grid.md
hybrid.md
ios-deploy.md
mobile-web.md
mobile_methods.md
touch-actions.md

troubleshooting.md
style-guide.md
grunt.md
how-to-write-docs.md
credits.md
)

  extra_files   = []
  ordered_files = []
  files.each do |file|
    index = order.index File.basename file

    if index
      ordered_files[index] = file
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

  data = ''

  files = file_glob File.expand_path(File.join(folder_to_glob, '**', '*.md'))
  files = order_files files

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

  index_file = File.expand_path(File.join(output_folder, 'index.md'))

  File.open(index_file, 'w') do |f|
    f.write header + data
  end
end