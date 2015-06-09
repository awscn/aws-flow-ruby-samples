require_relative '../cron_utils'
require_relative 'cron_activity'
require_relative 'cron_workflow'

# These are the initial parameters for the Simple Workflow

#
# @param job [Hash] 记录计划作业 (cron job)运行所需要的信息. 包含
#   一个corn 时间表达式的字符串, 一个待执行的函数(in activity.rb), 以及函数的调用参数
# @param base_time [Time] 工作流的开始时间
# @param interval_length [Integer] 重置历史的频次 (seconds)
# @return [Array] 计划调用(job)的时间列表
job = { cron: "* * * * *",  func: :add, args: [3,4]}

base_time = Time.now
# The internal length should be longer than the periodicity of the cron job.
# We have selected a short interval length (127 seconds) so that users can
# see the workflow continue as new on the swf console. The number 127 was
# particularly selected because it is the first prime number after 120
# (120 seconds = 2 minutes)
interval_length = 127

# Get the workflow client from CronUtils and start a workflow execution with
# the required options
CronUtils.new.workflow_client.run(job, base_time, interval_length)
