module IrcMachine
  module Plugin
    class Base
      def initialize(session)
        @session = session
      end
      attr_reader :session

      # Inherited from the old HttpController
      def ok(content, opts={})
        Rack::Response.new.tap do |response|
          response.status = 200
          response["Content-Type"] = opts[:content_type] || "text/plain"
          response.write content
        end
      end

      def not_found
        Rack::Response.new.tap do |response|
          response.status = 404
        end
      end

      def route(method, path, destination)
        # Close over the instance method and bind to a route.
        if destination.is_a? Symbol
          destination = lambda { |request, match| send(destination, request, match) }
        end

        IrcMachine::HttpRouter.send(:connect, method, path, destination)
      end
    end
  end
end
