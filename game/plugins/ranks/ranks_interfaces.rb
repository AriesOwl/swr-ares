module AresMUSH
  module Ranks
    module Interface
      
      def self.app_review(char)
        Ranks.app_review(char)
      end
    
      def self.rank(char)
        char.rank
      end
    end
  end
end