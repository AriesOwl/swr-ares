module AresMUSH
    module Fate
        class SkillRemoveCmd
            include CommandHandler

            attr_accessor :target_name, :skill_name
            
            def parse_args
                # Admin version
                if (cmd.args =~ /\=/)
                    args = cmd.parse_args(ArgParser.arg1_equals_arg2)
                    self.target_name = titlecase_arg(args.arg1)
                    .skill_name = titlecase_arg(args.arg2)
                 else
                    self.target_name = enactor_name
                    self.skill_name = titlecase_arg(cmd.args)
                end
            end
      
            def required_args
             [self.target_name, self.skill_name]
            end
      
            def check_can_set
                 nil if enactor_name == self.target_name
                 return nil if Fate.can_manage_abilities?(enactor)
                 return t('dispatcher.not_allowed')
            end     
      
            def check_chargen_locked
                return nil if Fate.can_manage_abilities?(enactor)
                Chargen.check_chargen_locked(enactor)
            end
      
            def handle
                ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          
                    skills = model.fate_skills
          
                if (!skill.has_key?(self.skill_name))
                     client.emit_failure t('fate.dont_have_skill')
                     return
                end
          
                skill.delete self.skill_name
                model.update(fate_skills: skills)
          
                Fate.update_refresh(model)
          
                client.emit_success t('fate.skill_removed')
                end 
            end
        end
    end
end