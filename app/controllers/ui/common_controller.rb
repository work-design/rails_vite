module Ui
  class CommonController < ActionController::Base

    def index
      path = Pathname.new "/#{params[:path]}.#{params[:format]}"

      if path.exist? && Rails.env.development?
        send_file path
      else
        head :ok
      end
    end

    def image
      file = "#{params[:path]}.#{params[:format]}"
      path = Rails.root.join('app/assets', 'images', file)

      if path.exist? && Rails.env.development?
        send_file path
      else
        head :ok
      end
    end

  end
end
