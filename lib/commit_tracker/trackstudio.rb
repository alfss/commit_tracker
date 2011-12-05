require "savon"
require "commit_tracker/error"

module CommitTracker
  
  # = CommitTracker::TrackStudio
  #
  # Cleint for TrackStudio
  class TrackStudio
    
    # Initializes the CommitTracker::TrackStudio
    #
    # == Examples
    #   ts = CommitTracker::TrackStudio.new(:url => 'http://ts.domain.com/TrackStudio/services/', 
    #                                       :login => 'user', 
    #                                       :password => 'qwerty')
    def initialize(options={})
      url       = options[:url]      || 'http://localhost/TrackStudio/services/'
      @login    = options[:login]    || 'login'
      @password = options[:password] || 'password'       
      
      Savon.configure do |config|
        config.soap_version = 2
      end
      
      @User = Savon::Client.new do
        wsdl.document = url + "User?wsdl"
      end
      
      @Task = Savon::Client.new do
        wsdl.document = url + "Task?wsdl"
      end
      
      @Message = Savon::Client.new do
        wsdl.document = url + "Message?wsdl"
      end
      
      @Step = Savon::Client.new do
        wsdl.document = url + "Step?wsdl"
      end
      
      @Acl = Savon::Client.new do
        wsdl.document = url + "Acl?wsdl"
      end
      
      @Bookmark = Savon::Client.new do
        wsdl.document = url + "Bookmark?wsdl"
      end
      
      @Category = Savon::Client.new do
        wsdl.document = url + "Category?wsdl"
      end
      
      @Constants = Savon::Client.new do
        wsdl.document = url + "Constants?wsdl"
      end
      
      @Export = Savon::Client.new do
        wsdl.document = url + "Export?wsdl"
      end
      
      @Filter = Savon::Client.new do
        wsdl.document = url + "Filter?wsdl"
      end
      
      @Find = Savon::Client.new do
        wsdl.document = url + "Find?wsdl"
      end
      
      @Index = Savon::Client.new do
        wsdl.document = url + "Index?wsdl"
      end
      
      @MailImport = Savon::Client.new do
        wsdl.document = url + "MailImport?wsdl"
      end
      
      @Prstatus = Savon::Client.new do
        wsdl.document = url + "Prstatus?wsdl"
      end
      
      @Registration = Savon::Client.new do
        wsdl.document = url + "Registration?wsdl"
      end
      
      @Registration = Savon::Client.new do
        wsdl.document = url + "Registration?wsdl"
      end
      
      @Report = Savon::Client.new do
        wsdl.document = url + "Report?wsdl"
      end
      
      @SCM = Savon::Client.new do
        wsdl.document = url + "SCM?wsdl"
      end
      
      @Template = Savon::Client.new do
        wsdl.document = url + "Template?wsdl"
      end
      
      @Udf = Savon::Client.new do
        wsdl.document = url + "Udf?wsdl"
      end
      
      @Workflow = Savon::Client.new do
        wsdl.document = url + "Workflow?wsdl"
      end
      
      @sessionId = nil
      begin
        response  = @User.request :soap, 
                                  :authenticate,
                                  :body => { :login => @login,
                                             :password => @password }
      
        @sessionId = response.to_hash[:authenticate_response][:return]
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
    end

    # return task id by number
    #
    # == Examples
    #
    #   taskId = ts.get_task_id(1234)
    def get_task_id(task_number)
      raise ErrorCommitTask, "task number is nil" if task_number.nil?
      begin    
        response = @Task.request  :soap, 
                                  :findTaskIdByQuickGo, 
                                  :body => { :sessionId => @sessionId.to_s, 
                                             :quickGo   => task_number }
                                                    
        taskId   = response.to_hash[:find_task_id_by_quick_go_response][:return]
        return taskId
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
    end
    
    
    # return message status id by name
    #
    # == Examples
    #
    #   msg_status = "New"
    #   mstatusId = ts.get_mstatus_id(taskId, msg_status)
    def get_mstatus_id(taskId, msg_status)
      raise ErrorCommitTask, "msg_status is nil" if msg_status.nil?
      begin
        response  = @Step.request :soap, 
                                  :getAvailableMstatusList, 
                                  :body => { :sessionId => @sessionId.to_s, 
                                             :taskId    => taskId }
                                             
        value = response.to_hash[:get_available_mstatus_list_response][:return]        

        if !value.nil?
          value = [value] if !value.kind_of?(Array)
        
          value.each do |item|
            return item[:id] if item[:name] == msg_status
          end
        end
        
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
      return nil
    end
    
    
    # return user id by name
    #
    # == Examples
    #
    #   userId = ts.get_user_id("user_1")
    def get_user_id(user)
      begin
        find_user = user || @login
        response  = @User.request :soap, 
                                  :findUserIdByQuickGo,
                                  :body => { :sessionId => @sessionId.to_s, 
                                             :quickGo   => find_user }
                                                     
        return response.to_hash[:find_user_id_by_quick_go_response][:return]
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end  
    end
    
    # return available workflows by task id
    #
    # == Examples
    #
    #   taskId        = ts.get_task_id(1234)
    #   workflow_list = ts.get_workflow_for_task(taskId)
    def get_workflow_for_task(taskId)
      begin
       response =  @Workflow.request :soap,
                                     :getAvailableWorkflowList,
                                     :body => { :sessionId => @sessionId.to_s,
                                                :taskId => taskId }
                                                
       return response.to_hash[:get_available_workflow_list_response][:return]                                    
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end                                  
    end
    
    # retrun available priority for workflow id
    #
    # == Examples
    #
    #   priorityId = ts.get_priority_for_wokflow(workflowId)
    def get_priority_for_wokflow(workflow_id)
      response = @Workflow.request :soap,
                                   :getPriorityList,
                                   :body => { :sessionId => @sessionId.to_s,
                                              :workflowId => workflow_id }

      value = response.to_hash[:get_priority_list_response][:return]
      return value
    end
       
    # return priority id by name and task id
    #
    # == Examples
    #
    #   taskId        = ts.get_task_id(1234)
    #   priorityId    = ts.get_priority_id(taskId, "Medium")
    def get_priority_id(taskId, priority)
      begin
        workflow_list = get_workflow_for_task(taskId)
        
        workflow_list = [workflow_list] if !workflow_list.kind_of?(Array)
        
        workflow_list.each do |workflow|
          value = get_priority_for_wokflow(workflow[:id])
          next if value.nil?
          
          value = [value] if !value.kind_of?(Array)
          
          value.each do |item|
            return item[:id] if item[:name] == priority
          end
        end
              
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
      return nil
    end
    
    # return priority id by message status id  and resolution name
    #
    # == Examples
    #
    #   resolutionId  = ts.get_resolution_id(mstatusId, "inProgress")
    def get_resolution_id(mstatusId, resolution)
      begin
        response  = @Workflow.request :soap, 
                                      :getResolutionList, 
                                      :body => { :sessionId => @sessionId.to_s, 
                                                 :mstatusId => mstatusId }
                                             
        value = response.to_hash[:get_resolution_list_response][:return]        

        if !value.nil?
          value = [value] if !value.kind_of?(Array)
        
          value.each do |item|
            return item[:id] if item[:name] == resolution
          end
        end

      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end      
      return nil
    end
    
    
    # return categoryes by task id
    #
    # == Examples
    #
    #   categoryes_list  = ts.get_category_list_for_task(taskId)
    def get_category_list_for_task(taskId)
      begin
      response =  @Category.request :soap, 
                                    :getCreatableCategoryList, 
                                    :body => { :sessionId => @sessionId.to_s,
                                               :taskId    => taskId }
                                               
      value = response.to_hash[:get_creatable_category_list_response][:return]
      
      value = [value] if !value.kind_of?(Array) and !value.nil?
      return value
      
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
    end
    
    # return category id by task id and name category
    #
    # == Examples
    #
    #   category  = ts.get_category_for_task(taskId, "Task")
    def get_category_for_task(taskId, category)
      begin
        categories_list = get_category_list_for_task(taskId)

        return nil if categories_list.nil?
        
        categories_list.each do |item|
          return item[:id] if item[:name] == category
        end
                
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end 
    end
    
    
    # delete task by id or number
    #
    # == Examples
    #
    #   ts.delete_task(:task_number => 1234)
    #   ts.delete_task(:task_number => taskId)
    def delete_task(options={})
      begin
        
        taskId = nil
        if !options[:task_number].nil? and options[:task_number].integer?
          taskId = get_task_id(options[:task_number]) 
        else
          taskId = options[:task_number]
        end
        
        @Task.request :soap, 
                      :deleteTask,
                      :body => { :sessionId => @sessionId.to_s,
                                 :taskId => taskId }
                                 
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end                            
    end
    
    # delete message by message id
    #
    # == Examples
    #
    #   ts.delete_message(:messageId => "4028929033561c0801335a5490e80433")
    def delete_message(options={})
      begin
        @Message.request :soap, 
                         :deleteMessage,
                         :body => { :sessionId => @sessionId.to_s,
                                    :messageId => options[:messageId] }
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
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
    #   taskId = ts.create_task(:name          => "example task 1"
    #                           :shortname     => "ex1",
    #                           :user          => "user_1",
    #                           :parent_number => 123,
    #                           :description   => "This is example task"
    #                           :priority      => "Normal",
    #                           :category      => "Task",
    #                           :budget_sec    => 3 * 3600,
    #                           :deadline_sec  => Time.now.to_i + 5 * 86400,
    #                           :udf_names     => ['one', 'two'],
    #                           :udf_values    => ['test', 4] )
    def create_task(options={})
      begin
        handlerUserId = get_user_id(options[:user])
        parentId      = get_task_id(options[:parent_number])
        priorityId    = get_priority_id(parentId, options[:priority]) if !options[:priority].nil?
        categoryId    = get_category_for_task(parentId, options[:category])
        
        options[:deadline_sec] *= 1000  if !options[:deadline_sec].nil?
        
        task_number = @Task.request :soap, 
                                    :createTask, 
                                    :body => {  :sessionId   => @sessionId.to_s,
                                                :categoryId  => categoryId,
                                                :shortname   => options[:shortname],
                                                :name        => options[:name],
                                                :description => options[:description],
                                                :budget      => options[:budget_sec],
                                                :deadline    => options[:deadline_sec],
                                                :priorityId  => priorityId,
                                                :parentId    => parentId,
                                                :handlerUserId  => handlerUserId,
                                                :handlerGroupId => nil,
                                                :udfNames    => options[:udf_names],
                                                :udfValues   => options[:udf_values] }                    
          
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
    end
    
    
    # create message and return message id
    #
    # [notice] if you api is broke and not return message id, method return "0"
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
    #    messageId = ts.create_message(:task_number => "1234",
    #                                  :msg_status => "Assigned",
    #                                  :comment => "test msg!!!!",
    #                                  :hrs => 3*3600,
    #                                  :user => "user_1", 
    #                                  :resolution => nil,
    #                                  :priority => "Normal",
    #                                  :budget_sec => nil,
    #                                  :deadline_sec => Time.now.to_i + 4 * 86400,
    #                                  :is_notify => true)
    def create_message(options={})
      begin     
        priorityId    = nil
        resolutionId  = nil
        
        options[:is_notify]     = false if options[:is_notify].nil?
        options[:comment]       = ""    if options[:comment].nil?
        options[:deadline_sec] *= 1000  if !options[:deadline_sec].nil?

        taskId         = get_task_id(options[:task_number])
        mstatusId      = get_mstatus_id(taskId, options[:msg_status])
        handlerUserId  = get_user_id(options[:user])
        
        priorityId     = get_priority_id(taskId, options[:priority]) if !options[:priority].nil?
        resolutionId   = get_resolution_id(mstatusId, options[:resolution]) if !options[:resolution].nil?
        
        message_number = @Message.request :soap, 
                                          :createMessage, 
                                          :body => { :sessionId      => @sessionId.to_s,
                                                     :taskId         => taskId,
                                                     :mstatusId      => mstatusId,
                                                     :text           => options[:comment],
                                                     :hrs            => options[:hrs],
                                                     :handlerUserId  => handlerUserId,
                                                     :handlerGroupId => nil,
                                                     :resolutionId   => resolutionId,
                                                     :priorityId     => priorityId,
                                                     :deadlineLong   => options[:deadline_sec],
                                                     :budget         => options[:budget_sec],
                                                     :sendMail       => options[:is_notify] }
        
      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
      
      #if message_number == nil than retrun 0
      if message_number.to_hash[:create_message_response][:return].nil?
        return "0"
      else
        return message_number.to_hash[:create_message_response][:return]
      end
    end
  end
end