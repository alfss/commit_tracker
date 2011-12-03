require "commit_tracker/error"
require "commit_tracker/trackstudio"

module CommitTracker
  class Task
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
        return @commit.create_task(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
    
    def delete(options={})
      case @type
      when 'trackstudio'
        return @commit.delete_task(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
  end
end