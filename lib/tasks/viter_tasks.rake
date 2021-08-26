namespace :viter do

  desc 'Viter Build'
  task build: [:environment] do
    Viter.compile
  end

  desc 'viter clobber'
  task clobber: [:environment] do
    Viter.clobber
  end

end
