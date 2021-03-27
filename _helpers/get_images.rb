require "down"
require 'fileutils'

post_files = Dir['_posts/**/*']
post_files.each { |f| puts f }

post_files.each do |post_file|
  content = File.read(post_file)

  urls = []
  content.scan(/^\!\[\]\((.*)\)$/) { |match| urls << match.first }

  urls.uniq.each.with_index do |url, i|
    dest = "images/#{post_file.gsub('.md', '')}/#{i + 1}.png"
    puts dest

    FileUtils.mkpath File.dirname(dest)
    tempfile = Down.download(url)
    FileUtils.mv(tempfile.path, dest)

    new_url = "![]({{ site.baseurl }}/#{dest})"
    puts new_url

    before = "![](#{url})"
    after = new_url
    puts "file #{post_file}, before: #{before}, after: #{new_url}"
    content = content.gsub(before, after)
  end

  File.write(post_file, content)
end
