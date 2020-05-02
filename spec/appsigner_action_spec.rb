describe Fastlane::Actions::AppsignerAction do
  before do
    @domain = 'https://appsigner.redmadrobot.dev'
    @secret_key = '5bf2bd278b91ce59c8765d22c6d9edd5f32078c418ca3d651e39c474644b545e'
    @apk_path = 'spec/app-debug.apk'
    @params = {
        domain: @domain,
        secret_key: @secret_key,
        apk_path: @apk_path
    }
  end

  describe 'Invalid Parameters' do
    it 'raises an error if no domain was given' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          appsigner({
            secret_key: '#{@secret_key}',
            apk_path:   '#{@apk_path}'
          })
        end").runner.execute(:test)
      end.to raise_error "No domain"
    end

    it 'raises an error if no secret_key was given' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          appsigner({
            domain:   '#{@domain}',
            apk_path: '#{@apk_path}'
          })
        end").runner.execute(:test)
      end.to raise_error "No secret_key"
    end

    it 'raises an error if no apk_path was given' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          appsigner({
            domain:     '#{@domain}',
            secret_key: '#{@secret_key}',
          })
        end").runner.execute(:test)
      end.to raise_error "No apk_path"
    end
  end
end
