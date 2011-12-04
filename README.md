CommitTracker
=============

Simple create task/message to bug tracker.
Now support only TrackStudio

TODO: 
Redmine
Jira


Example
=======

``` ruby
require "commit_tracker"
#Message authentication
commit = CommitTracker::Message.new(:type => 'trackstudio',
                                    :url => 'http://ts.domain.com/TrackStudio/services/', 
                                    :login => 'user', 
                                    :password => 'qwerty')
                                    
#Create Message
messageId = commit.create(:user => "user_1", 
                          :hrs => 3*3600,
                          :comment => "test msg!!!!",
                          :task_number => 8845,
                          :msg_status => "Report time As", 
                          :deadline_sec => Time.now.to_i)

#Delete Message
commit.delete(:messageId => messageId)

#Task authentication
commit = CommitTracker::Task.new(:type => 'trackstudio',
                                 :url => 'http://ts.domain.com/TrackStudio/services/', 
                                 :login => 'user', 
                                 :password => 'qwerty')
                                        
#Create Task
taskId = commit.create(:parent_number => 4885, 
                       :name => 'test_task',
                       :user => 'user_1',
                       :description => "test comment",
                       :category => 'Task',
                       :budget_sec => 3600)

                                                                                                        
#Delete Task
commit.delete(:task_number => 16069 )
commit.delete(:task_number => taskId )


```

Copyright (c) 2011 Sergey V. Kravchuk <alfss.obsd@gmail.com>, released under the BSD license
