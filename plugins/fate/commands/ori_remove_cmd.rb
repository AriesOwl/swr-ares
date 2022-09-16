module AresMUSH    
    module Fate
      class OrRemoveCmd
        include CommandHandler
        
        attr_accessor :target_name, :or_name
        
        def parse_args
          # Admin version
          if (cmd.args =~ /\=/)
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            self.target_name = titlecase_arg(args.arg1)
            self.or_name = titlecase_arg(args.arg2)
          else
            self.target_name = enactor_name
            self.or_name = titlecase_arg(cmd.args)
          end
        end
        
        def required_args
          [self.target_name, self.or_name]
        end
        
        def check_can_set
          return nil if enactor_name == self.target_name
          return nil if Fate.can_manage_abilities?(enactor)
          return t('dispatcher.not_allowed')
        end     
        
        def check_chargen_locked
          return nil if Fate.can_manage_abilities?(enactor)
          Chargen.check_chargen_locked(enactor)
        end
        
        def handle
          ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
            
            or = model.fate_or || []
            
            if (!or.include?(self.or_name))
              client.emit_failure t('fate.dont_have_or')
              return
            end
            
            or.delete self.or_name
            model.update(fate_or: or)
            
            client.emit_success t('fate.or_removed')
          end
        end
      end
    end
  end