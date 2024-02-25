json.partial! 'learning_path', learning_path: @learning_path

json.courses @learning_path.courses do |course|
  json.extract! course, :id, :name
end
