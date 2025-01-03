#如何下载安装Postman？
https://www.postman.com/downloads/

#如何使用Postman (实战 微信公众号平台)
1 创建请求
1.1 获得appid和secret
 打开微信公众平台网址https://mp.weixin.qq.com/
 找到接口测试号申请，进入微信公众账号测试号申请系统
 微信扫一扫，获取自己微信号的appID和appsecret
 微信公众平台API文档如下链接：
 https://developers.weixin.qq.com/doc/offiaccount/Basic_Information/Get_access_token.html

1.2 获取token值
 https请求方式: GET 
 https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET
 access_token 获取到的凭证
 expires_in 凭证有效时间，单位：秒

1.3 获取公众号已创建的标签接口
 输入url地址：https://api.weixin.qq.com/cgi-bin/tags/get
 参数为刚刚的access_token值， 

1.4 创建标签接口
 输入url地址：https://api.weixin.qq.com/cgi-bin/tags/create
 参数为刚刚的access_token值， 
 请求体为：在Body中，raw输入，以json格式输入，
 {"tag":{"name":"test"}}
    
2 接口关联
2.1 使用json提取器，提取access_token的值
 在Tests(scripts-post response)中首先查看响应的信息，然后使用json提取access_token参数以及其的值，最后将access_token的值设置为全局变量，
 //打印responseBaby返回值
 //console.log(responseBody)
 //使用JSON提取结果,结果为键值对形式
 //var result = JSON.parse(responseBody)
 //access_token键中的值设置为全局变量
 //pm.globals.set("access_token",result.access_token);

 //解析响应体
 var jsonResponse = pm.response.json();
 //提取access_token
 var access_token = jsonResponse.access_token;
 //设置全局变量
 pm.globals.set("access_token",access_token);
 //可选：在控制台输出access_token,方便调试
console.log("Access Token:",access_token);

2.2 使用正则提取器，提取access_token的值
 上面为JavaScript脚本
2.3 提取响应头的信息（Cookie……）
2.4 从Cookie里面提取变量
 //从cookie中提取变量
 var contentType = pm.response.headers.get('Content-Type');

3 Postman内置动态参数以及自定义动态参数
接口测试中尝尝出现接口的参数值使用随机数。
3.1 内置动态参数
 {{$timestamp}}	生成当前时间的时间戳
 {{$randomInt}}	生成0-1000之间的随机数
 {{$guid}}		生成随机GUID字符串
 {"tag":{"name":"广东{{$timestamp}}"}}
 
 3.2 自动动态参数（重点），为name值使用
3.2.1 自定义时间戳
首先，在脚本运行之前，调用Date中的now方法，获取当前时间，并且将当前时间设置为全局变量
 scripts-pre-request script
 //获取现在的事件，传入nowtime变量中
 var nowtime = Date.now()
 //设置为全局变量
 pm.globals.set("nowtime", nowtime);

 3.2.2 接口请求停留3秒
  //让接口请求停留3秒（效果如python的sleep(3)）
  const sleep = (milliseconds) => {
    const start = Date.now();
    while(Date.now() <= start + milliseconds){}
  };
  sleep(3000);
  console.log("1");
4 业务闭环
 业务闭环是创建，修改，查询，删除的流程。

 4.1 修改标签接口
    新建接口为“修改标签接口”，在脚本运行之间设置全局变量nowtime_2，用于修改name的值
    var nowtime_2 = Date.now()
    pm.globals.set("nowtime_2", nowtime_2); 
    修改标签接口的请求体为：
    {"tag":{"id":101,"name":"广东{{$nowtime_2}}"}}
 4.2 删除标签接口
    #新建接口为“删除标签接口”，在脚本运行之间设置全局变量nowtime_3，用于删除name的值
    #var nowtime_3 = Date.now()
    #pm.globals.set("nowtime_3", nowtime_3);
    #删除标签接口的请求体为：
    #{"tag":{"id":101}}
    {"tag":{"id":{{tag_id}}}}
    #在创建标签接口(scripts-post response)中设置全局变量tag_id
    // 获取响应体
    var responseBody = pm.response.text();
    // 使用正则表达式提取 id 的值
    var tag_id = responseBody.match(/"id":(\d+)/);
    // 检查是否成功提取到 id
    if (tag_id && tag_id[1]) {
    // 将 id 的值设置为全局变量
    pm.globals.set("tag_id", tag_id[1]);
    console.log("tag_id 已设置为全局变量: " + tag_id[1]);
    } else {
    console.log("响应中未找到 id 键");
    }
4.3 实现业务闭环
走一遍完整的闭环，“创建标签接口”，“修改标签接口”，“查询已创建的标签接口”，删除标签接口。
5 环境变量与全局变量
5.1 环境变量
环境变量是一组键值对，用于存储环境相关的信息，如host、port、access_token等。
5.2 全局变量
全局变量是一组键值对，用于存储全局相关的信息，如access_token、tag_id等。

6.断言
    //状态码断言
    pm.test("Status code is 200", function () {
    pm.expect(pm.response.code).to.equal(200);
    });
    //业务断言 返回值里有没有access_token字符串
    pm.test("1",function () {
    pm.expect(pm.response.text()).to.include("access_token");
    });
断言的作用
断言是用来验证接口返回的结果是否符合预期的，如果符合预期则测试通过，否则测试失败。

postman内置的动态参数无法做断言，所以必须使用自定义的动态参数。
在tests中不能使用{{}}方法取全局变量，必须使用以下三种方式：

pm.globals.("golbals_variable")
globals.["golbals_variable"]
globals.golbals_variable




