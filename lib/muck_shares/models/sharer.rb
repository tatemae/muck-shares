module MuckShares
  module Models
    module Sharer
      
      included do
        has_many :shares, :dependent => :destroy, :order => 'created_at ASC', :foreign_key => :shared_by_id
      end

    end
  end
end