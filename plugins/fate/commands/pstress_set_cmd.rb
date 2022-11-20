module AresMUSH    
    module Fate
      class PStressSetCmd
        include CommandHandler
        
        attr_accessor :target_name, :pstress_name
        
        def parse_args
          # Admin version
          if (cmd.args =~ /\=/)
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            self.target_name = titlecase_arg(args.arg1)
            self.pstress_name = titlecase_arg(args.arg2)
          else
            self.target_name = enactor_name
            self.pstress_name = titlecase_arg(cmd.args)
          end
        end
        
        def required_args
          [self.target_name, self.pstress_name]
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
            
            pstress = model.fate_pstress || []
            
            if (pstress.include?(self.pstress_name))
              client.emit_failure t('fate.already_have_pstress')
              return
            end
            
            pstress << self.pstress_name
            model.update(fate_pstress: pstress)
            
            client.emit_success t('fate.pstress_set')
          end
        end
      end
    end
  end