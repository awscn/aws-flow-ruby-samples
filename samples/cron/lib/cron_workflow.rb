require 'parse-cron'
require_relative 'cron_activity'
require_relative '../cron_utils'

# CronWorkflow class defines the workflows for the Cron sample
# 这个工作流基于一个计划安排的表达式,周期性的运行工作流活动.
class CronWorkflow
  # Ruby 的类定义本身就是可执行的代码
  # extend 是个函数.
  extend AWS::Flow::Workflows

  # AWS::Flow::Workflows 的 workflow 方法被 引入为类方法,在这里直接执行, 是定义工作流的入口点.
  # 在此处 run (实例方法) 方法就是工作流的入口点
  workflow :run do
    {
      version: CronUtils::WF_VERSION,
      default_task_list: CronUtils::WF_TASKLIST,
      default_execution_start_to_close_timeout: 600,
    }
  end

  # activity_client 方法和前面的 workflow 方法一样都是通过 extend AWS::Flow::Workflows 引入的
  # 使用 activity_client 方法创建一个 activity client(活动的客户端操作句柄)
  # 这个句柄可以用来调度活动. 第一个参数是一个 Symbol ,创建的句柄就保存在这里
  # 第二个参数 block 被 activity_client 方法里头一系列元编程的动作貌似是的生成的 activity 对象也是 CronActivity 的实例
  activity_client(:activity) { { from_class: "CronActivity" } }

  # 这是工作流的入口.它确定运行任务的调度周期,并调度任务运行.
  # interval_length 的缺省值被设置为素数(601) 以避免周期性任务互相重叠.
  # 601 是最接近 600 (10 分钟) 的素数.
  # @param (see #get_schedule_times)
  def run(job, base_time = Time.now, interval_length = 601)
    puts "Workflow has started" unless is_replaying?

    # 获取一个任务需要被调度执行的时间列表
    times_to_schedule = get_schedule_times(job, base_time, interval_length)

    # Schedule all invocations of the job asynchronously
    # 异步调度该 job 的所有调用
    puts "Scheduling activity invocations" unless is_replaying?
    times_to_schedule.each do |time|
      # async_create_timer 是AWS::Flow 的方法,用来创建一个定时器,在指定时间后执行提供的 Block
      async_create_timer(time) do
        # activity 是在第 53 行创建的 ,run_job 是类型 CronActivity 的实例方法
        # job 是 run 传入的参数,是个hash ,从里头提取出要执行的函数和参数
        activity.run_job(job[:func], *job[:args])
      end
    end

    # Update base_time to move to the next interval of time
    base_time += times_to_schedule.last
    create_timer(times_to_schedule.last)

    # continue_as_new 是 AWS::Flow::Workflows 的方法,所有 extend AWS::Flow::Workflows
    # 的类都可以使用. 这个方法被调用后工作流会在完成后再次执行(给定的间隔之后)
    puts "Workflow is continuing as new" unless is_replaying?
    continue_as_new(job, base_time, interval_length)
  end


  # 这是一个工具函数,用来确定计划作业在当前时间间隔内的调度时间表,
  # 并为这个调度时间表生成一个列表数据结构
  #
  # @param job [Hash] 记录计划作业 (cron job)运行所需要的信息. 包含
  #   一个corn 时间表达式的字符串, 一个待执行的函数(in activity.rb), 以及函数的调用参数
  # @param base_time [Time] 工作流的开始时间
  # @param interval_length [Integer] 重置历史的频次 (seconds)
  # @return [Array] 计划调用(job)的时间列表
  def get_schedule_times(job, base_time, interval_length)

    return [] if job.empty?
    # Generate a cron_parser for each job
    cron_parser = CronParser.new(job[:cron])

    # Store the times at which this job will be called within the given interval
    times_to_schedule = []
    next_time = cron_parser.next(base_time)
    while(base_time <= next_time and next_time < base_time + interval_length) do
      times_to_schedule.push((next_time - base_time).to_i)
      next_time = cron_parser.next(next_time)
    end

    # Checks if the interval_length is less than the periodicity of the task
    if times_to_schedule.empty?
      raise ArgumentError, "interval length should be longer than periodicity"
    end

    # Return the list of times at which the job needs to be scheduled
    times_to_schedule
  end

  # Helper method to check if Flow is replaying the workflow. This is used to
  # avoid duplicate log messages
  def is_replaying?
    decision_context.workflow_clock.replaying
  end
end

# Start a WorkflowWorker to work on the CronWorkflow tasks
CronUtils.new.workflow_worker.start if $0 == __FILE__
