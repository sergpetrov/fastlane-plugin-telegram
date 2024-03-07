module Fastlane
  module Actions
    class TelegramAction < Action
      def self.run(params)
        UI.message("Sending message to a telegram channel")

        token = params[:token]
        chat_id = params[:chat_id]
        text = params[:text]
        parse_mode = params[:parse_mode]
        file_path = params[:file]
        mime_type = params[:mime_type]
        api_url = params[:api_url]

        file = nil
        if file_path != nil 
          if File.exist?(file_path)
            if mime_type == nil 
              UI.user_error!("The mime type, required for send file")
            end

            file = UploadIO.new(file_path, mime_type)
          end
        end

        if file_path != nil && file == nil 
          UI.message("Can't find file on path location")
        end

        method = (file == nil ? "sendMessage" : "sendDocument")
        base_url = "api.telegram.org"
        url = api_url.empty? ? base_url : api_url
        uri = URI.parse("https://#{url}/bot#{token}/#{method}")
        
        http = Net::HTTP.new(uri.host, uri.port)
        if params[:proxy]
          proxy_uri = URI.parse(params[:proxy])
          http = Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
        end
        http.use_ssl = true

        require 'net/http/post/multipart'
        text_parameter = (file == nil ? "text" : "caption")
        request = Net::HTTP::Post::Multipart.new(uri, 
        { 
          "chat_id" => chat_id,
          text_parameter => text,
          "parse_mode" => parse_mode,
          "document" => file
        })

        response = http.request(request)
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
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :file,
                                           env_name: "TELEGRAM_FILE",
                                         description: "File path to the file to be sent",
                                             optional: true,
                                                 type: String),
                   FastlaneCore::ConfigItem.new(key: :mime_type,
                                           env_name: "TELEGRAM_FILE_MIME_TYPE",
                                         description: "Mime type of file to be sent",
                                             optional: true,
                                                 type: String),
                   FastlaneCore::ConfigItem.new(key: :parse_mode,
                                           env_name: "TELEGRAM_PARSE_MODE",
                                        description: "Param (Markdown / HTML) for using markdown or HTML support in message",
                                           optional: true,
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :proxy,
                                           env_name: "TELEGRAM_PROXY",
                                        description: "Proxy URL to be used in network requests. Example: (https://123.45.67.89:80)",
                                           optional: true,
                                               type: String),
                   FastlaneCore::ConfigItem.new(key: :api_url,
                                           env_name: "TELEGRAM_API_URL",
                                        description: "Provide alternative api url for your bot without scheme. Example: (api.telegram.org)",
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
