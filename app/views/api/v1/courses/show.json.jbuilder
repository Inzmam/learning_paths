json.partial! 'course', course: @course

json.talents @course.talents do |talent|
  json.extract! talent, :id, :name
end
