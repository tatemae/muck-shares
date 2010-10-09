#include MuckShares::Models::MuckSharer
module MuckShares
  module Models
    module MuckSharer
      
      extend ActiveSupport::Concern
      included do
        has_many :shares, :dependent => :destroy, :order => 'created_at ASC', :foreign_key => :shared_by_id
      end

    end
  end
end