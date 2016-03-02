require 'sinatra'
require 'redcarpet'

get '/:directory/:file' do |d, f|
  markdown("#{d}/#{f}")
end

get '/:directory/' do |d|
  markdown("#{d}/index")
end

get '/:file' do |f|
  markdown("#{f}")
end

get '/' do
  markdown("index")
end

helpers do
  def markdown(filename)
    f = File.read("#{filename}.md", :encoding => Encoding::UTF_8)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(f)
  end
end
