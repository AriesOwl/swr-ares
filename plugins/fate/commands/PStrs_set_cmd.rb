module AresMUSH
    module Fate
        class PStrsSetCmd
            include CommandHandler
            
            attr_accessor :target_name, :pstrs

            def parse_args
                # Admin version
                if (cmd.args =~ /\=/)
                    args = cmd.parse_args(ArgParser.arg1_equals_arg2)
                    self.target_name = titlecase_arg(args.arg1)
                    self.pstrs = titlecase_arg(args.arg2)
                else
                    self.target_name = enactor_name
                    self.pstrs = titlecase_arg(cmd.args)
                end
            end
            
            def required_args
                [self.target_name, self.pstrs]
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
                
                    pstrs = model.fate_pstrs || []

                   def self.physical_stress_thresh
                        if (Vigor == 1 || Vigor == 2)
                            return OOO
                        elsif (Vigor >= 3)
                            return OOOO
                        else
                            return OO
                        end
                        
                        clinet.emit_success t('fate.pstrs_Set')
                    end
                end
            end
        end
    end
end