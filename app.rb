require 'sinatra'
require 'redcarpet'

get '/:directory/:file' do |d, f|
  markdown("#{d}/#{f}", "/#{d}/")
end

get '/:directory/' do |d|
  markdown("#{d}/index", "/#{d}/")
end

get '/:file' do |f|
  markdown(f.to_s, '/')
end

get '/' do
  markdown('index', '/')
end

helpers do
  def markdown(filename, directory)
    filename = 'nofile' unless File.exist?("md/#{filename}.md")
    file = File.read("md/#{filename}.md", encoding: Encoding::UTF_8)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true, highlight: true).render(file)
    @body = markdown
    @title = markdown.match(%r{<h1>(.*)</h1>})[1]
    @back = "#{directory}"
    erb :index
  end
end
