Dir[File.expand_path('slash_commands', __dir__) + '/*.rb'].sort.each do |file|
  require file
end
