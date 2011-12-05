require "commit_tracker/error"
require "commit_tracker/trackstudio"

module CommitTracker
  
  # = CommitTracker::Message
  #
  # Abstract class for message
  class Message
    
    # Initializes the CommitTracker::Message
    #
    #
    # * type tracker (:type)
    # * url api (:url)
    # * auth login (:login)
    # * password  (:password)
    #
    # == Examples
    #   commit = CommitTracker::Message.new(:type => 'trackstudio'
    #                                       :url => 'http://ts.domain.com/TrackStudio/services/', 
    #                                       :login => 'user', 
    #                                       :password => 'qwerty')
    def initialize(options={})
      @type   = options[:type] || 'trackstudio'
      @commit = nil
      case @type
      when 'trackstudio'
        @commit = TrackStudio.new(options)
      end
    end
    
    # create message and return message id
    #
    # * task number (:task_number)
    # * message status (:msg_status)
    # * text message (:comment)
    # * time spent (:hrs)
    # * assigned user (:user)
    # * change resolution task (:resolution)
    # * change priority task (:priority)
    # * add budget time for task in seconds (:budget_sec)
    # * set deadline day (:deadline_sec)
    # * send notify to email (:is_notify)
    #
    # == Examples
    #
    #    messageId = commit.create(:task_number => "1234",
    #                              :msg_status => "Assigned",
    #                              :comment => "test msg!!!!",
    #                              :hrs => 3*3600,
    #                              :user => "user_1", 
    #                              :resolution => nil,
    #                              :priority => "Normal",
    #                              :budget_sec => nil,
    #                              :deadline_sec => Time.now.to_i + 4 * 86400,
    #                              :is_notify => true)
    def create(options={})
      case @type
      when 'trackstudio'
        return @commit.create_message(options)
      else
        raise ErrorCommitTask, "error name tracker"
      end
    end
    
    # delete message by message id
    #
    # == Examples
    #
    #   ts.delete(:messageId => "4028929033561c0801335a5490e80433")
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