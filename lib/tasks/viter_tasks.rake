namespace :rails_vite do

  desc 'RailsVite Build'
  task build: [:environment] do
    RailsVite.compile
  end

  desc 'rails_vite clobber'
  task clobber: [:environment] do
    RailsVite.clobber
  end

end
