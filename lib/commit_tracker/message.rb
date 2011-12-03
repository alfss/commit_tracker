require "commit_tracker/error"
require "commit_tracker/trackstudio"

module CommitTracker
  class Message
    def initialize(options={})
      @type   = options[:type] || 'trackstudio'
      @commit = nil
      case @type
      when 'trackstudio'
        @commit = TrackStudio.new(options)
      end
    end
    
    def create(options={})
      case @type
      when 'trackstudio'
        return @commit.create_message(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
    
    def delete(options={})
      case @type
      when 'trackstudio'
        return @commit.delete_message(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
  end
end