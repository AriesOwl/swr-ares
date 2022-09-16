module AresMUSH    
    module Fate
      class HcSetCmd
        include CommandHandler
        
        attr_accessor :target_name, :hc_name
        
        def parse_args
          # Admin version
          if (cmd.args =~ /\=/)
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            self.target_name = titlecase_arg(args.arg1)
            self.hc_name = titlecase_arg(args.arg2)
          else
            self.target_name = enactor_name
            self.hc_name = titlecase_arg(cmd.args)
          end
        end
        
        def required_args
          [self.target_name, self.hc_name]
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
            
            hc = model.fate_hc || []
            
            if (hc.include?(self.hc_name))
              client.emit_failure t('fate.already_have_hc')
              return
            end
            
            hc << self.hc_name
            model.update(fate_hc: hc)
            
            client.emit_success t('fate.hc_added')
          end
        end
      end
    end
  end