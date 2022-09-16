module AresMUSH    
    module Fate
      class TrSetCmd
        include CommandHandler
        
        attr_accessor :target_name, :tr_name
        
        def parse_args
          # Admin version
          if (cmd.args =~ /\=/)
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            self.target_name = titlecase_arg(args.arg1)
            self.tr_name = titlecase_arg(args.arg2)
          else
            self.target_name = enactor_name
            self.tr_name = titlecase_arg(cmd.args)
          end
        end
        
        def required_args
          [self.target_name, self.tr_name]
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
            
            tr = model.fate_tr || []
            
            if (tr.include?(self.tr_name))
              client.emit_failure t('fate.already_have_tr')
              return
            end
            
            tr << self.tr_name
            model.update(fate_tr: tr)
            
            client.emit_success t('fate.tr_added')
          end
        end
      end
    end
  end