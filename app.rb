require 'sinatra'
require 'redcarpet'

get '/:directory/:file' do |d, f|
  t = File.read("#{d}/#{f}.md", :encoding => Encoding::UTF_8)
  Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(t)
end

get '/:file' do |f|
  t = File.read("#{f}.md", :encoding => Encoding::UTF_8)
  Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(t)
end

get '/' do
  t = File.read("index.md", :encoding => Encoding::UTF_8)
  Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(t)
end
