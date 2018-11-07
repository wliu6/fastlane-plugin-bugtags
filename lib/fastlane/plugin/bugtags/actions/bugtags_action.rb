require 'fastlane/action'
require_relative '../helper/bugtags_helper'

module Fastlane
  module Actions
    class BugtagsAction < Action
      def self.run(params)
        UI.message("The bugtags plugin is working!")
        command = []
        command << "curl"
        command << "\"https://work.bugtags.com/api/apps/symbols/upload\""
        command << "--write-out \"%{http_code}\" --silent"
        command += handle_params(params)
        command += handle_plistinfo(params)
        shell_command = command.join(' ')
        result = Actions.sh(shell_command)
        return result
      end

      def self.handle_params (params)
        result = []
        result << "-F \"file=@#{params[:dsym].shellescape};type=application/octet-stream\""
        result << "-F \"app_key=#{params[:app_key].shellescape}\""
        result << "-F \"secret_key=#{params[:secret_key].shellescape}\""
        return result
      end

      def self.handle_plistinfo (params)
        result = []
        result << "-F \"version_name=#{params[:app_version].shellescape}\""
        result << "-F \"version_code=#{params[:app_build].shellescape}\""
        return result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload symbols to Bugtags"
      end

      def self.authors
        ["wliu6"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "fastlane plugin for Bugtags https://work.bugtags.com"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :dsym,
                                      env_name: "FL_BUGTAGS_DSYM_FILE", 
                                      description: "the dSYM.zip file to upload to Bugtags", 
                                      verify_block: proc do |value|
                                        UI.user_error!("No dsym for BugtagsAction given, pass using `dsym: 'dsym file's path'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                      env_name: "FL_BUGTAGS_APP_VERSION",
                                      description: "the version in your project's info.plist",
                                      verify_block: proc do |value|
                                        UI.user_error!("No version for BugtagsAction given, pass using `dsym: 'app_version file's path'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :app_build,
                                      env_name: "FL_BUGTAGS_APP_BUILD",
                                      description: "the build version in your project's info.plist",
                                      verify_block: proc do |value|
                                        UI.user_error!("No build version for BugtagsAction given, pass using `app_build: 'build version'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :app_key,
                                      env_name: "FL_BUGTAGS_APP_KEY",
                                      description: "Bugtags App ID key e.g. 29f35c87cb99e10e00c7xxxx",
                                      verify_block: proc do |value|
                                        UI.user_error!("No App ID for BugtagsAction given, pass using `app_key: 'Bugtags App ID key'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :secret_key,
                                      env_name: "FL_BUGTAGS_SECRET_KEY",
                                      description: "Bugtags App Secret key e.g. 29f35c87cb99e10e00c7xxxx",
                                      verify_block: proc do |value|
                                        UI.user_error!("No App Secret for BugtagsAction given, pass using `secret_key: 'Bugtags App Secret key'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                      end)
                                      #is_string: false, # true: verifies the input is a string, false: every kind of value
                                      #default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
