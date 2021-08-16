namespace :viter do

  desc 'Viter Compile'
  task compile: [:environment] do
    Viter.compile
  end

  desc 'viter clobber'
  task clobber: [:environment] do
    Viter.clobber
  end

end
