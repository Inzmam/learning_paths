json.partial! 'author', author: @author

json.courses @author.courses do |course|
  json.extract! course, :id, :title
end
