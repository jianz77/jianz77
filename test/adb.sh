# 查看设备列表
adb devices
# 重启设备
adb reboot
# 进入设备的shell
adb shell
# 安装应用
adb install <apk_file>
# 卸载应用
adb uninstall <package_name>
# 推送文件到设备
adb push <local_file> <remote_path>
#从设备拉取文件
adb pull <remote_file> <local_path>
# 查看设备日志
adb logcat
# 截屏
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png <local_path>
# 录屏
adb shell screenrecord /sdcard/screenrecord.mp4
adb pull /sdcard/screenrecord.mp4 <local_path>
# 查看设备信息
adb shell getprop
# 清除应用数据
adb shell pm clear <package_name>
# 启动应用
adb shell am start -n <package_name>/<activity_name>
# 停止应用
adb shell am force-stop <package_name>
# 查看当前运行的activity
adb shell dumpsys activity activities | grep mResumedActivity
# 查看设备电池状态
adb shell dumpsys battery
# 查看设备内存使用情况
adb shell dumpsys meminfo
# 查看设备存储使用情况
adb shell df
