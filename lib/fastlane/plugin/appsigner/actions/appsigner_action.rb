module Fastlane
  module Actions
    class AppsignerAction < Action
      def self.run(params)
        require 'net/http'
        require 'uri'
        uri = URI.parse('%s/api/v1/app/sign/' % params[:domain])

        header = {
            'X-SIGNER-SECRET': params[:secret_key],
            'Content-Disposition': 'inline; filename="%s"' % File.basename(params[:input_file]),
            'Content-Type': 'application/octet-stream'
        }
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = File.read(params[:input_file])
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        unless response.kind_of? Net::HTTPSuccess
          print("response.body = %s\n" % response.body)
          raise response.error!
        end
        output_file = params[:output_file] || params[:input_file]
        open(output_file, "wb") do |file|
          file.write(response.body)
        end
      end

      def self.description
        "AppSigner"
      end

      def self.authors
        ["Valeriy Makarshin"]
      end

      def self.details
        "AppSigner"
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :domain,
                                         env_name: "APPSIGNER_DOMAIN",
                                         description: "The domain of your AppSigner service",
                                         optional: false,
                                         type: String,
                                         verify_block: proc do |value|
                                           UI.user_error!("No domain") if value.to_s.length == 0
                                         end),
            FastlaneCore::ConfigItem.new(key: :secret_key,
                                         env_name: "APPSIGNER_SECRET_KEY",
                                         description: "Secret key from AppSigner",
                                         optional: false,
                                         type: String,
                                         verify_block: proc do |value|
                                           UI.user_error!("No secret_key") if value.to_s.length == 0
                                         end),
            FastlaneCore::ConfigItem.new(key: :input_file,
                                         env_name: "APPSIGNER_INPUT_FILE",
                                         description: "The path to your apk/aab for sign",
                                         optional: false,
                                         type: String,
                                         verify_block: proc do |value|
                                           UI.user_error!("No input_file") if value.to_s.length == 0
                                         end),
            FastlaneCore::ConfigItem.new(key: :output_file,
                                         env_name: "APPSIGNER_OUTPUT_FILE",
                                         description: "Output apk/aab file. If you don't specify params, the plugin will override input file",
                                         optional: true,
                                         type: String,
                                         verify_block: proc do |value|
                                           UI.user_error!("No output_file") if value.to_s.length == 0
                                         end)
        ]
      end

      def self.is_supported?(platform)
        :android == platform
      end
    end
  end
end
