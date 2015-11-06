module Lita
  module Handlers
    class Whatthecommit < Handler

      route(/^(commit)/i, :getCommit, command: false, help: { "commit" => "Get a helpful git commit message"})

      def getName(username)
        if redis.get(username) then
          requestedName = redis.get(username)
        else
          requestedName = username
        end
      end

      def getCommit(response)
        name = getName(response.user.name)
        
        case rand(5)
          when 0
            response.reply("How about this #{name}?")
          when 1
            response.reply("This ought to do the trick")
          when 2
            response.reply("Really #{name}? Alright, use this")
          when 3
            response.reply("The laziness you extrude to us all astounds me, #{name}")
          when 4
            response.reply("Ok then...")
        end

        http_response = http.get("http://whatthecommit.com/index.txt")
        commit = http_response.body
        response.reply(">>>#{commit}")

        if commit.include? "fuck" or commit.include? "crap" or commit.include? "shit"
          arbitraryComment(response, 3)
        #else
          #arbitraryComment(response, rand(3))
        end
      end

      def reply_target(message:)
        if message.source.private_message
          Source.new(user: message.user, private_message: true)
        else
          Source.new(room: message.source.room)
        end
      end

      def arbitraryComment(response, num)
        case num
          when 0
            response.reply("You should really thing of something more clever...")
          when 1
            response.reply("Oh no, what have I done?")
          when 2
            response.reply("I think this is how Skynet started.")
          when 3
            response.reply("You might want to add a NSFW tag to that one")
        end
      end
      Lita.register_handler(self)
    end
  end
end
