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

