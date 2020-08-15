class Tags < Thor
  desc "update", "updates tags associated to posts"

  def update
    puts "Processing tags"
    c = 0
    tagfiles = Dir["tags/*.md"]
    tagfiles.each do |tf|
      tf = File.basename(tf, "*.md").downcase
    end
    newtag = []
    posts = Dir["_posts/*.md"]
    posts.each do |x|
      file = File.open(x)
      file_data = file.readlines.map(&:chomp)
      file_data.each do |line|
        if line.include? "tags:"
          line.chomp
          c = line.size - 2
          tags = line[7..c]
          tags = tags.gsub(", ", "~")
          tagname = tags.gsub(" ", "-").downcase
          tagname = tagname.split("~")
          tags = tags.split("~")
          tags.each do |tg|
            ttg = "tags/" + tg.gsub(" ", "-").downcase + ".md"
            unless tagfiles.include?(ttg)
              unless newtag.include?(tg)
                newtag.push(tg)
              end
            end
          end
        end
      end

      file.close
    end

    puts "Found #{newtag.count} new #{tag_label(newtag)}."
    newtag.each do |tg|
      create_tagfile(tg)
    end
  end

  private

  def tag_label(tags)
    tags.count == 1 ? "tag" : "tags"
  end

  def create_tagfile(tag)
    name = tag.gsub(" ", "-").downcase
    filename = "tags/#{name}.md"
    if File.exist?(filename)
      abort("#{filename} already exists!")
    else
      puts "Creating new tag file: #{tag}"

      open(filename, "w") do |data|
        data << "---\n"
        data << "layout: blog_by_tag\n"
        data << "title: 'Articles by tag: #{tag}'\n"
        data << "tag: #{name}\n"
        data << "---"
      end
    end
  end
end
