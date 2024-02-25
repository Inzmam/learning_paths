json.array! @authors do |author|
  json.partial! 'author', author: author
end
