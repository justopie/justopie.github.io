require "stringex"
require "date"

class Jekyll < Thor
  desc "new", "create a new post"
  method_option :editor, :default => "code"

  def new(*title)
    title = title.join(" ")
    date = Time.now.strftime("%Y-%m-%d")

    create_file(date, title)
  end

  desc "next", "create the next post (tuesday & thursday)"
  method_option :editor, :default => "code"

  def next(*title)
    title = title.join(" ")

    # We want the day after the latest post
    # to exclude it from the process
    latest = (Date.parse Dir["_posts/*.md"].sort.last[7..16]) + 1
    #latest = Time.now.strftime("%Y-%m-%d")
    # get next Tuesday and next Thursday
    dates = [get_next_day(latest, 2), get_next_day(latest, 4)]
    date = dates.min.strftime("%Y-%m-%d")

    create_file(date, title)
  end

  private

  def create_file(date, title)
    filename = "_posts/#{date}-#{title.to_url}.md"

    if File.exist?(filename)
      abort("#{filename} already exists!")
    end

    puts "Creating new post: #{filename}"
    open(filename, "w") do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title.gsub(/&/, "&amp;").capitalize!}\""
      post.puts "published: false"
      post.puts "tags: []"
      post.puts "author: "
      post.puts "---"
    end

    system(options[:editor], ".")
  end

  def get_next_day(date, day_of_week)
    date + ((day_of_week - date.wday) % 7)
  end
end
