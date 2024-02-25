json.array! @learning_paths do |learning_path|
  json.partial! 'learning_path', learning_path: learning_path
end
