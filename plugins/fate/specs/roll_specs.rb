module AresMUSH
  module Fate
    describe Fate do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_luck") { 3 }
        # Note:  By seeding the random number generator, we can avoid the randomness.
        #   If you use Kernel.srand(22), the first 10 die rolls in tests will always be:  
        #      [6, 5, 5, 1, 5, 7, 7, 4, 5, 1]
        Kernel.srand 22

        stub_translate_for_testing
      end
      
      describe :roll_skill do
        before do
          @char = double
          allow(@char).to receive(:name) { "Charlie" }
          allow(Fate).to receive(:roll_fate_dice) { 0 }
        end
  
        context "base roll" do
          it "should roll a number by itself" do
            Fate.roll_skill(nil, "4").should eq 4
          end
        
          it "should roll an ability ladder rating" do
            Fate.roll_skill(nil, "Good").should eq 3
          end
        
          it "should roll a person's skill" do 
            expect(Fate).to receive(:skill_rating).with(@char, "Firearms") { 2 }
            Fate.roll_skill(@char, "Firearms").should eq 2
          end
        
          it "should return 0 for a skill with no character" do 
            Fate.roll_skill(nil, "Firearms").should eq 0
          end
        end
        
        context "positive modifers" do        
          it "should roll a number plus modifier" do
            Fate.roll_skill(nil, "4+1").should eq 5
          end
        
          it "should roll an ability ladder rating plus mod" do
            Fate.roll_skill(nil, "Good+2").should eq 5
          end
        
          it "should roll a person's skill plus mod" do 
            expect(Fate).to receive(:skill_rating).with(@char, "Firearms") { 2 }
            Fate.roll_skill(@char, "Firearms+2").should eq 4
          end        
        end
        
        context "negative modifers" do        
          it "should roll a number minus modifier" do
            Fate.roll_skill(nil, "4-1").should eq 3
          end
        
          it "should roll an ability ladder rating minus mod" do
            Fate.roll_skill(nil, "Good-2").should eq 1
          end
        
          it "should roll a person's skill minus mod" do 
            expect(Fate).to receive(:skill_rating).with(@char, "Firearms") { 1 }
            Fate.roll_skill(@char, "Firearms-2").should eq -1
          end        
        end
        
      end
    end
  end
end