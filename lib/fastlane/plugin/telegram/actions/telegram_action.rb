module Fastlane
  module Actions
    class TelegramAction < Action
      def self.run(params)
        UI.message("Sending message to a telegram channel")

        token = params[:token]
        chat_id = params[:chat_id]
        text = params[:text]
        parse_mode = params[:parse_mode]

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
                                        description: "Unique identifier for the target chat (not in the format @channel). For getting chat id you can send any message to your bot and get chat id from response https://api.telegram.org/botYOUR_TOKEN/getupdates",
                                           optional: false,
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :text,
                                           env_name: "TELEGRAM_TEXT",
                                        description: "Text of the message to be sent",
                                           optional: false,
                                               type: String)
                   FastlaneCore::ConfigItem.new(key: :parse_mode,
                                           env_name: "TELEGRAM_PARSE_MODE",
                                        description: "Flag for using markdown or HTML support in message",
                                           optional: true,
                                               type: String)
                ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
