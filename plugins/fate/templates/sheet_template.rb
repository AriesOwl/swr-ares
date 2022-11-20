module AresMUSH
  module Fate
    class SheetTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end
     
      def approval_status
        Chargen.approval_status(@char)
      end
              
      def skills
        list = []
        skills = @char.fate_skills || {}
        skills.sort.each_with_index do |(name, rating), i| 
           list << format_skill(name, rating, i)
        end
        list
      end

      def format_skill(name, rating, i)
        name = "%xh#{name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        rating_text = Fate.rating_name(rating)
        "#{linebreak}#{left(name, 16)} #{left(rating_text, 20)}"
      end
      
      def hc
        (@char.fate_hc || []).sort
      end

      def tr 
        (@char.fate_tr || []).sort
      end

      def ori 
        (@char.fate_ori || []).sort
      end

      def aspects
        (@char.fate_aspects || []).sort
      end
      
      def stunts
        (@char.fate_stunts || {}).sort
      end

      def stress
        (@char.physical_stress_thresh(model) || []).sort
        (@char.mental_stress_thresh(model) || []).sort
      end
    end
  end
end