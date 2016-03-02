require 'sinatra'
require 'redcarpet'

get '/:directory/:file' do |d, f|
  markdown("#{d}/#{f}")
end

get '/:directory/' do |d|
  markdown("#{d}/index")
end

get '/:file' do |f|
  markdown(f.to_s)
end

get '/' do
  markdown('index')
end

helpers do
  def markdown(filename)
    if File.exist?("md/#{filename}.md")
      f = File.read("md/#{filename}.md", encoding: Encoding::UTF_8)
    else
      f = File.read("md/nofile.md", encoding: Encoding::UTF_8)
    end
    m = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true, highlight: true).render(f)
    @body = m
    @title = m.match(/<h1>(.*)<\/h1>/)[1]
    erb :index
  end
end
