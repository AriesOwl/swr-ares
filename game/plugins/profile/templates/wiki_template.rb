module AresMUSH
  module Profile
    class WikiTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/wiki.erb"
      end
      
      def fullname
        @char.demographic(:fullname)
      end
      
      def gender
        @char.demographic(:gender)
      end
      
      def height
        @char.demographic(:height)
      end
      
      def physique
        @char.demographic(:physique)
      end
      
      def hair
        @char.demographic(:hair)
      end
      
      def eyes
        @char.demographic(:eyes)
      end
      
      def age
        age = @char.age
        age == 0 ? "" : age
      end
      
      def actor
        @char.actor
      end
      
      def birthdate
        dob = @char.demographic(:birthdate)
        !dob ? "" : ICTime::Api.ic_datestr(dob)
      end
      
      def callsign
        @char.demographic(:callsign)
      end
      
      def faction
        @char.group_value("Faction")
      end
      
      def position
        @char.group_value("Position")
      end
      
      def colony
        @char.group_value("Colony")
      end
      
      def department
        @char.group_value("Department")
      end

      def rank
        @char.rank
      end
            
      def background
        @char.background
      end

      def hooks
        #TODO @char.hooks.map { |h, v| "%R* **#{h}** - #{v}" }.join
        ""
      end
    end
  end
end