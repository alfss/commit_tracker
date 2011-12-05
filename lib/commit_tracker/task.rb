require "commit_tracker/error"
require "commit_tracker/trackstudio"

module CommitTracker
  
  # = CommitTracker::Task
  #
  # Abstract class for task
  class Task
    
    # Initializes the CommitTracker::Task
    #
    #
    # * type tracker (:type)
    # * url api (:url)
    # * auth login (:login)
    # * password  (:password)
    #
    # == Examples
    #   commit = CommitTracker::Task.new(:type => 'trackstudio'
    #                                    :url => 'http://ts.domain.com/TrackStudio/services/', 
    #                                    :login => 'user', 
    #                                    :password => 'qwerty')
    def initialize(options={})
      @type   = options[:type] || 'trackstudio'
      @commit = nil
      case @type
      when 'trackstudio'
        @commit = TrackStudio.new(options)
      end
    end
    
    # create task and return task id
    #
    # Options:
    # * name task (:name)
    # * short name task (:shortname)
    # * assigned user (:user)
    # * parent task (:parent_number)
    # * description (:description)
    # * priority (:priority)
    # * category task (:category)
    # * budget time for task in seconds (:budget_sec)
    # * deadline day (:deadline_sec)
    # * name custom fields (:udf_names)(array)
    # * value custom fields (:udf_values)(array)
    #
    # == Examples
    #
    #   taskId = commit.create(:name          => "example task 1"
    #                         :shortname     => "ex1",
    #                         :user          => "user_1",
    #                         :parent_number => 123,
    #                         :description   => "This is example task"
    #                         :priority      => "Normal",
    #                         :category      => "Task",
    #                         :budget_sec    => 3 * 3600,
    #                         :deadline_sec  => Time.now.to_i + 5 * 86400,
    #                         :udf_names     => ['one', 'two'],
    #                         :udf_values    => ['test', 4] )
    def create(options={})
      case @type
      when 'trackstudio'
        return @commit.create_task(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
    
    # delete task by id or number
    #
    # == Examples
    #
    #   commit.delete(:task_number => 1234)
    #   commit.delete(:task_number => taskId)
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