desc 'Viter Compile'

namespace :viter do

  task compile: [:environment] do
    Viter.compile
  end

  task clobber: [:environment] do
    Viter.clobber
  end

end
