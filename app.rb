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
    # @title = filename.to_s
    @title = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(f).match(/<h1>(.*)<\/h1>/)[1]
    @body = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(f)
    erb :index
  end
end
