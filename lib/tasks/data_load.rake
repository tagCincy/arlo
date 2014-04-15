namespace :data_loader do
  desc "Loads App Data"
  task :load => :environment do
    data_loader = DataLoader.new
    data_loader.load
  end
end