require 'sinatra'
require 'redcarpet'

set :index, 'index'
set :edit, 'edit'
set :nofile, 'nofile'
set :editlink, true
set :backlink, true
set :toplink, true

get '/:directory/:file' do |d, f|
  if params['edit']
    editMarkdown("#{d}/#{f}", "/#{d}/")
  else
    markdown("#{d}/#{f}", "/#{d}/")
  end
end

get '/:directory/' do |d|
  if params['edit']
    editMarkdown("#{d}/#{settings.index}", "/#{d}/")
  else
    markdown("#{d}/#{settings.index}", "/#{d}/")
  end
end

get '/:file' do |f|
  if params['edit']
    editMarkdown(f.to_s, '/')
  else
    markdown(f.to_s, '/')
  end
end

get '/' do
  if params['edit']
    editMarkdown(settings.index, '/')
  else
    markdown(settings.index, '/')
  end
end

post '/:directory/:file' do |d, f|
  saveMarkdown("#{d}/#{f}", "/#{d}/", params['body'])
end

post '/:directory/' do |d|
  saveMarkdown("#{d}/#{settings.index}", "/#{d}/", params['body'])
end

post '/:file' do |f|
  saveMarkdown(f.to_s, '/', params['body'])
end

post '/' do
  saveMarkdown(settings.index, '/', params['body'])
end

helpers do
  def markdown(filename, directory)
    @filename = filename
    @directory = directory
    filename = settings.nofile unless File.exist?("md/#{filename}.md")
    file = File.read("md/#{filename}.md", encoding: Encoding::UTF_8)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, fenced_code_blocks: true, highlight: true).render(file)
    if markdown.match(%r{<h1>(.*)</h1>}).nil?
      title = ''
    else
      title = markdown.match(%r{<h1>(.*)</h1>})[1]
    end
    @title = title
    @body = markdown
    @back = "#{directory}"
    @editlink = settings.editlink
    @backlink = settings.backlink
    @toplink = settings.toplink
    erb :index
  end

  def editMarkdown(filename, directory)
    @filename = filename
    @directory = directory
    filename = settings.nofile unless File.exist?("md/#{filename}.md")
    file = File.read("md/#{filename}.md", encoding: Encoding::UTF_8)
    if file.match(%r{#\s(.*)}).nil?
      title = ''
    else
      title = file.match(%r{#\s(.*)})[1]
    end
    @title = title
    @body = file
    @back = "#{directory}"
    @editlink = settings.editlink
    @backlink = settings.backlink
    @toplink = settings.toplink
    erb :edit
  end

  def saveMarkdown(filename, directory, body)
    unless File.exist?("md/#{filename}.md")
      File.open("md/#{filename}.md","w") do |file|
        file.puts body
      end
    else
      File.write("md/#{filename}.md", body)
    end
    markdown(filename, directory)
  end
end
