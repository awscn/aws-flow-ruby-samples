require_relative '../cron_utils'

# CronActivity class defines a set of activities for the Cron sample.
class CronActivity
  # Ruby 的类定义本身就是可执行的代码
  # extend 是个函数.
  extend AWS::Flow::Activities

  # activity 方法用来定义工作流中的活动.
  # 它接受一个活动的名字列表,和一个用来指定这些活动选项的代码块
  activity :run_job, :add, :sum do
    {
      default_task_list: CronUtils::ACTIVITY_TASKLIST,
      version: CronUtils::ACTIVITY_VERSION,
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 30,
    }
  end

  # 这个活动输入一个函数,这个函数会被调用执行
  # @param func [lambda] 将会被活动调用执行的函数
  # @return [void] 返回传入的函数被调用后的执行结果
  def run_job(func, *args)
    puts "Running a job"
    if self.method(func).arity > 1
      self.send(func, *args)
    else
      self.send(func, args)
    end
  end

  # 这个活动将两个数相加
  def add(a,b)
    puts "Adding two numbers"
    a + b
  end

  # sum 活动没有被定义,它在哪里?

end

# Start an ActivityWorker to work on the CronActivity tasks
CronUtils.new.activity_worker.start if __FILE__ == $0
