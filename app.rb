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
    f = File.read("#{filename}.md", encoding: Encoding::UTF_8)
    m = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(f)
    @body = m
    @title = m.match(/<h1>(.*)<\/h1>/)[1]
    erb :index
  end
end
