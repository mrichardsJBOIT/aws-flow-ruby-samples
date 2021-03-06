# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../../utils'

# HumanTaskActivities defines the activities required for the human_task recipe.
class HumanTaskActivities
  extend AWS::Flow::Activities

  activity :automated_activity, :send_notification do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  # Notice the manual_completion option in this activity. Setting the
  # manual_completion to true will let SimpleWorkflow know that this activity
  # needs manual completion.
  activity :human_activity do
    {
      version: "1.0",
      default_task_list: "activity_tasklist",
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 120,
      manual_completion: true
    }
  end

  def automated_activity
    puts "activity: automated_activity"
  end

  # This activity gets the task_token from the activity_execution_context and
  # prints it out so that the user can enter it when prompted.
  def human_activity
    puts "activity: human_activity"
    # Use the activity_execution_context available to all Activity classes that
    # extend AWS::Flow::Activities to fetch the task token for this activity
    # task.
    task_token = activity_execution_context.task_token
    puts "Task received, completion token:#{task_token}\n"
    return "default string"
  end

  def send_notification(input)
    puts "activity: send_notification: #{input}"
  end
end
