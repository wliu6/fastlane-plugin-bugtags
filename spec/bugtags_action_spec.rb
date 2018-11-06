describe Fastlane::Actions::BugtagsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The bugtags plugin is working!")

      Fastlane::Actions::BugtagsAction.run(nil)
    end
  end
end
