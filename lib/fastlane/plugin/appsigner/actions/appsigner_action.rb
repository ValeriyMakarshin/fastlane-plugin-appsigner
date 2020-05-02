require 'fastlane/action'
require_relative '../helper/appsigner_helper'

module Fastlane
  module Actions
    class AppsignerAction < Action
      def self.run(params)
        uri = URI.parse('%s/api/v1/app/sign/' % params[:signer_url])

        header = {
            'X-SIGNER-SECRET': params[:secret_key],
            'Content-Disposition': 'inline; filename="%s"' % File.basename(params[:apk_path]),
            'Content-Type': 'application/octet-stream'
        }
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = File.read(params[:apk_path])
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        unless response.kind_of? Net::HTTPSuccess
          print("response.body = %s\n" % response.body)
          raise response.error!
        end
        open(params[:apk_path], "wb") do |file|
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
            FastlaneCore::ConfigItem.new(key: :signer_url,
                                         env_name: "APPSIGNER_URL",
                                         description: "Url of your AppSigner service",
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
            FastlaneCore::ConfigItem.new(key: :apk_path,
                                         env_name: "APPSIGNER_APK_PATH",
                                         description: "The path to your apk for sign",
                                         optional: false,
                                         type: String,
                                         verify_block: proc do |value|
                                           UI.user_error!("No apk_path") if value.to_s.length == 0
                                         end)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
