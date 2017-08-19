module Fastlane
  module Actions
    class TelegramAction < Action
      def self.run(params)
        UI.message("Sned message to a telegram channel")

        token = params[:token]
        chat_id = params[:chat_id]
        text = params[:text]

        uri = URI.parse("https://api.telegram.org/bot#{token}/sendMessage")
        response = Net::HTTP.post_form(uri, {:chat_id => chat_id, :text => text})
      end

      def self.description
        "Allows post messages to telegram channel"
      end

      def self.authors
        ["sergpetrov"]
      end

      def self.return_value
        response
      end

      def self.details
        "Allows post messages to telegram channel"
      end

      def self.available_options
        [
                   FastlaneCore::ConfigItem.new(key: :token,
                                           env_name: "TELEGRAM_TOKEN",
                                        description: "A unique authentication token given when a bot is created",
                                           optional: false,
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :chat_id,
                                           env_name: "TELEGRAM_CHAT_ID",
                                        description: "Unique identifier for the target chat or username of the target channel (in the format @channelusername)",
                                           optional: false,
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :text,
                                           env_name: "TELEGRAM_TEXT",
                                        description: "Text of the message to be sent",
                                           optional: false,
                                               type: String)
                ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
