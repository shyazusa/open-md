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
    filename = 'nofile' unless File.exist?("md/#{filename}.md")
    file = File.read("md/#{filename}.md", encoding: Encoding::UTF_8)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true, highlight: true).render(file)
    @body = markdown
    @title = markdown.match(/<h1>(.*)<\/h1>/)[1]
    erb :index
  end
end
