desc 'Viter Compile'

namespace :viter do

  task compile: [:environment] do
    Viter.compile
  end

end
