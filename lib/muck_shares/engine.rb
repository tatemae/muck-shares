require 'muck_shares'
require 'rails'

module MuckShares
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-shares'
    end
    
    initializer 'muck_shares.helpers' do
      ActiveSupport.on_load(:action_view) do
        include MuckSharesHelper
      end
    end
    
  end
end