# AttendanceSphinx - Creating reports based on data from ACS sphinx
#     Copyright (C) 2011  Sergey V. Kravchuk <alfss.obsd@gmail.com>
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "savon"
require "commit_tracker/error"

module CommitTracker
  class TrackStudio
  
    def add_hours(user, message, hours_in_sec, date_deadline, num_task, url_trackstudio)
      # 
      # url_trackstudio = get_commit_message_api_url
    
      Savon.configure do |config|
        config.soap_version = 2
      end

      client_users = Savon::Client.new do
        wsdl.document = url_trackstudio + "User?wsdl"
      end

      client_task = Savon::Client.new do
        wsdl.document = url_trackstudio + "Task?wsdl"
      end

      client_msg = Savon::Client.new do
        wsdl.document = url_trackstudio + "Message?wsdl"
      end

      client_step = Savon::Client.new do
        wsdl.document = url_trackstudio + "Step?wsdl"
      end

      #interrupt handling :)
      begin 
        #authenticate
        response  = client_users.request :soap, 
                                         :authenticate,
                                         :body => { :login => get_commit_message_login,
                                                    :password => get_commit_message_password }

        sessionId = response.to_hash[:authenticate_response][:return]
      
        #get task id
        response_tmp = client_task.request :soap, 
                                           :findTaskIdByQuickGo, 
                                           :body => { :sessionId => sessionId.to_s, 
                                                      :quickGo   => num_task }
                                                    
        taskId       = response_tmp.to_hash[:find_task_id_by_quick_go_response][:return]
      
        #get message statuses
        mstatusId    = nil
        response_tmp = client_step.request :soap, 
                                           :getAvailableMstatusList, 
                                           :body => { :sessionId => sessionId.to_s, 
                                                      :taskId    => taskId }

        response_tmp.to_hash[:get_available_mstatus_list_response][:return].each do |item|
          if item[:name] == get_commit_message_type
            mstatusId = item[:id]
          end
        end

        #get assigned user id
        response_tmp = client_users.request :soap, 
                                            :findUserIdByQuickGo,
                                            :body => { :sessionId => sessionId.to_s, 
                                                       :quickGo   => user }
                                                     
        handlerUserId = response_tmp.to_hash[:find_user_id_by_quick_go_response][:return]

        #create message
        message_number = client_msg.request :soap, :createMessage, :body => { :sessionId      => sessionId.to_s,
                                                                              :taskId         => taskId,
                                                                              :mstatusId      => mstatusId,
                                                                              :text           => message,
                                                                              :hrs            => hours_in_sec,
                                                                              :handlerUserId  => handlerUserId,
                                                                              :handlerGroupId => "",
                                                                              :resolutionId   => "",
                                                                              :priorityId     => "",
                                                                              :deadlineLong   => date_deadline * 1000,
                                                                              :budget         => "",
                                                                              :sendMail       => false}

      rescue Savon::SOAP::Fault => e
        raise ErrorCommitTask, e.to_hash[:fault][:reason][:text]
      end
    
      if message_number.to_hash[:create_message_response][:return].nil?
        return "0"
      else
        return message_number.to_hash[:create_message_response][:return]
      end
      
    end
  end
end