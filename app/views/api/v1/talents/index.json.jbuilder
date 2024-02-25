json.array! @talents do |talent|
  json.partial! 'talent', talent: talent
end
