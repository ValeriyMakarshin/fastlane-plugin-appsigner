describe Fastlane::Actions::AppsignerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The appsigner plugin is working!")

      Fastlane::Actions::AppsignerAction.run(nil)
    end
  end
end
