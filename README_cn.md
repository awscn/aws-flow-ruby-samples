AWS Flow Framework for Ruby Samples and Recipes
===============================================

This project contains sample code and recipes for the AWS Flow Framework
for Ruby.

-   [Prerequisites](#prerequisites)
-   [Downloading the Sample Code](#downloading-the-sample-code)
-   [Samples](#samples)
-   [Recipes](#recipes)
-   [For More Information](#for-more-information)

Downloading the Sample Code
---------------------------

To view or download the code for all of the AWS Flow Framework for Ruby
recipes and samples, go to:

-   [https://github.com/awslabs/aws-flow-ruby-samples](https://github.com/awslabs/aws-flow-ruby-samples)

Prerequisites for Running the Samples
-------------------------------------

The *AWS Flow Framework for Ruby* is required, which can be obtained and
installed using the information here:

-   [https://aws.amazon.com/swf/flow/](https://aws.amazon.com/swf/flow/)

If you already have [Ruby](https://www.ruby-lang.org/) and
[RubyGems](http://rubygems.org/) installed, you can install the framework and
all of the gems required by the samples by opening a terminal window, changing
to the directory where you've cloned or downloaded the samples, and typing:

~~~~
bundle install
~~~~

This will install all of the requirements that are listed in the `Gemfile` in
the repository's base directory.

For more information about setting up the AWS Flow Framework for Ruby,
see [Installing the AWS Flow Framework for
Ruby](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/installing.html)
in the *AWS Flow Framework for Ruby Developer Guide*.

### Samples

#### booking

The *Booking* 例子演示了一个
[同步](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
工作流模式. 该示例会等待两个活动完成: a car
reservation 和 airline reservation. 当两个活动都完成时, 再发送一个确认(confirmation).
所有的活动都是异步方式执行的.

Code + info: [samples/booking](samples/booking/)

#### cron

The *Cron* sample 基于一个计划安排的表达式周期性的运行工作流活动.

Code + info: [samples/cron](samples/cron/)

#### cron\_with\_retry

The *CronWithRetry* 例子演示如何在运行一个已调度任务(scheduled task)时使用`exponential_retry` 选项.
一旦工作流完成, `continue_as_new` 选项使得工作流在下一个调度周期中重新运行.

Code + info: [samples/cron\_with\_retry](samples/cron_with_retry/)

#### deployment

The *Deployment*  例子演示了一个完整工作流的各个应用组件的部署方式.
一个 YAML 配置文件描述了应用程序栈结构. 示例中的工作流使用这个描述文件
作为输入,模拟了文件中表述的部署过程.

Code + info: [samples/deployment](samples/deployment/)

#### file\_processing

The *FileProcessing* 例子演示了一个媒体处理案例.
示例中的工作流从 Amazon S3 桶中下载文件,创建一个`.zip` 文件并且回传到S3.
这个例子主要演示了 Amazon SWF 的任务路由(task routing)特性. 

Code + info: [samples/file\_processing](samples/file_processing/)

#### hello\_world

The *HelloWorld* 例子实现了一个非常简单的工作流,它掉用一个活动打印出 " Hello World".
这个例子演示了 swf framework 的基本用法.包括实现工作流和活动的协作逻辑,
以及创建工作执行器(Workers)来运行工作流和活动.

Code + info: [samples/hello\_world](samples/hello_world/)

#### periodic

The *Periodic* 例子实现了一个长时间运行的工作流,它会周期性的执行一个活动.
工作流设计上可以把一次工作流执行作为一次新的执行重新开始,这种方式实现如何在一个非常长的时间中运行任务.

Code + info: [samples/periodic](samples/periodic/)

#### split\_merge

The *SplitMerge* 例子演示你 [并行分隔 parallel
split](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-synchronization)
然后 [简单合并 simple
merge](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/programming-workflow-patterns.html#programming-workflow-patterns-simple-merge)
的工作流模式. 它同时启动多个工作流活动然后使用 `wait_for_all` 等待它们全部执行完成.

Code + info: [samples/split\_merge](samples/split_merge/)

### Recipes

#### branch


The **Branch** 代码基提供了一个方案来 *并行执行动态数量的活动* .

Code + info: [recipes/branch](recipes/branch/)

#### child\_workflow

The **ChildWorkflow** 代码基提供了一个方案来 *在一个工作流执行过程中启动一个子工作流*.

Code + info: [recipes/child\_workflow](recipes/child_workflow/)

#### choice

The **Choice** 方案演示了如何使用一个选择器(choice)来 *执行一个或多个活动*,
或者 *execute multiple activities from a larger group*.

Code + info: [recipes/choice](recipes/choice/)

#### conditional\_loop

The **ConditionalLoop** 代码基提供了一个方案来 *并行执行动态数量的活动* .

Code + info: [recipes/conditional\_loop](recipes/conditional_loop/)

#### handle\_error

The **HandleError** 代码基提供了一个方案来 *根据异常的类型来响应异步活动中的异常* 和
*处理异步活动中的异常并完成清理动作*.

Code + info: [recipes/handle\_error](recipes/handle_error/)

#### human\_task

The **HumanTask** 代码基提供了一个方案来 * 手工完成活动*.

Code + info: [recipes/human\_task](recipes/human_task/)

#### pick\_first\_branch

The **PickFirstBranch** 代码基提供了一个方案来 to * 并行执行多个活动,然后选择完成最快的那个结果*.

Code + info: [recipes/pick\_first\_branch](recipes/pick_first_branch/)

#### retry\_activity

The **RetryActivity** 方案演示如何:

-   应用一个重试策略 to *all invocations of an activity*
-   指定一个重试策略给 *activity client*, a *block of code*,
    或者给 a *specific invocation of an activity*
-   重试活动s *without jitter*, or with *custom jitter logic*
-   重试活动s with *custom retry policies* 


Code + info: [recipes/retry\_activity](recipes/retry_activity/)

#### wait\_for\_signal

The **WaitForSignal** code provides a recipe to *wait for an external
signal and take a different code path if the signal is received*.

The **WaitForSignal** 代码基提供了一个方案来 *等等一个外部信号,并根据收到的信号来选择不同的代码路径*.

For More Information
--------------------

For more information about the Amazon Simple Workflow service and the
Amazon Flow Framework for Ruby, consult the following resources:

-   [AWS Flow Framework for Ruby Developer
    Guide](http://docs.aws.amazon.com/amazonswf/latest/awsrbflowguide/)
-   [AWS Flow Framework for Ruby API
    Reference](https://docs.aws.amazon.com/amazonswf/latest/awsrbflowapi/)
-   [AWS Flow Framework](http://aws.amazon.com/swf/flow/)
-   [Amazon Simple Workflow Service](http://aws.amazon.com/swf/)

