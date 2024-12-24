#为什么要做接口测试？
接口的由来,连接前后端以及移动端。
因为不同端的工作进度不一样，所以需要对开始出来的接口进行接口测试。
#做接口测试的好处：
1、节约时间,缩短项目成本
2、提高工作效率
3、提高系统的健壮性
#Postman简介
Postman是一个可扩展的API开发和测试协同平台工具，可以快速集成到CI/CD管道中。旨在简化测试和开发中的API工作流。
Postman 工具有 Chrome 扩展和独立客户端，推荐安装独立客户端。
Postman 有个 workspace 的概念，workspace 分 personal 和 team 类型。Personal workspace 只能自己查看的 API，Team workspace 可添加成员和设置成员权限，成员之间可共同管理 API。
#如何下载安装Postman？
https://www.postman.com/downloads/
Postman的主要功能有请求、测试、环境、监视、历史、集合、工具、设置等。
#如何使用Postman 举例一个请求
#1. 打开Postman客户端
#2. 点击左上角的 "New" 按钮，选择 "Request"
#3. 在弹出的窗口中输入请求的名称和描述，然后点击 "Save to" 按钮选择保存的集合
#4. 在请求窗口中选择请求类型（GET, POST, PUT, DELETE等）
#5. 在URL输入框中输入请求的URL，例如：https://jsonplaceholder.typicode.com/posts
#6. 如果是GET请求，直接点击 "Send" 按钮发送请求
#7. 如果是POST请求，选择 "Body" 选项卡，选择 "raw" 并将类型设置为 "JSON"，然后在文本框中输入请求的JSON数据，例如：
# {
#   "title": "foo",
#   "body": "bar",
#   "userId": 1
# }
#8. 点击 "Send" 按钮发送请求
#9. 在下方的响应窗口中查看请求的响应数据



如何将请求参数化
#1. 打开Postman客户端
#2. 点击左上角的 "New" 按钮，选择 "Environment"
#3. 在弹出的窗口中输入环境的名称和变量，然后点击 "Add" 按钮添加变量
#4. 在请求窗口中使用 {{variable_name}} 的格式引用变量，例如：https://jsonplaceholder.typicode.com/posts/{{postId}}
#5. 在发送请求前，选择环境，这样请求中的变量会被替换为环境中的实际值
如何创建Postman Tests

如何创建测试集合
如何使用Collection Runner 运行集合
如何使用Newman运行集合
面试的时候会问的问题：
