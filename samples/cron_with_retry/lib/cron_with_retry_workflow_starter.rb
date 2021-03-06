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

require_relative '../cron_with_retry_utils'
require_relative 'cron_with_retry_activity'
require_relative 'cron_with_retry_workflow'

# These are the initial parameters for the Simple Workflow

# @param job [Hash] information about the job that needs to be run. It
#   contains a cron string, the function to call (in activity.rb), and the
#   function call's arguments. The jobs should be short lived to avoid creating
#   a drift in the  scheduling of activities since the workflow will wait for
#   the job to finish before it continues as new.
# @param base_time [Time] time to start the cron workflow
# @param interval_length [Integer] how often to reset history (seconds)
job = { cron: "* * * * *",  func: :unreliable_add, args: [3,4]}

base_time = Time.now
# The internal length should be longer than the periodicity of the cron job.
# We have selected a short interval length (127 seconds) so that users can
# see the workflow continue as new on the swf console. The number 127 was
# particularly selected because it is the first prime number after 120
# (120 seconds = 2 minutes)
interval_length = 127

# Get the workflow client from CronUtils and start a workflow execution with
# the required options
CronWithRetryUtils.new.workflow_client.run(job, base_time, interval_length)
