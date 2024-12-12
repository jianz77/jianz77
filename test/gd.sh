
VAE疲劳驾驶事件(内置)
参数名	类型	描述/参数值
eventCode	string	事件Code：EVENT_VAE_FATIGUE_IDENTIFY
eventData	JSON string	
以下参数为eventData的二级参数
taskId	int64	任务ID
eventId	string	 事件id
VAEVersion	string	vae版本
lon	string	经度
lat	string	纬度
timestamp	int64	事件发生时间戳，毫秒
type	int	本次疲劳类型，1-闭眼，2-低头
注：10.11及以上，只有1闭眼，2低头纳入分神事件中
percent	int	置信度
times	int	疲劳时长占比，0~100，-1未识别到人
statType	int	取值是0：第一个配置识别结果、1：第二个配置识别结果