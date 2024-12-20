1基本命令
#初始化仓库
git init
#克隆远程仓库到本地
git clone
#查看提交日志  commit id
git log
#添加文件到暂存区
git add #添加当前目录修改的文件
#提交更改
git commit -s     #git commit -m "提交更改并添加提交信息"
#查看仓库的配置信息
git config --list

2分支操作
#查看所有分支
git branch
#创建新分支
git branch zj1
#切换分支
git checkout zj2
#创建并切换新分支
git checkout -b zj3
#删除分支
git branch -d zj1
#查看当前分支
git branch --show-current
#合并分支
git merge zj3 #将指定分支合并到当前分支

3远程仓库操作
#查看远程仓库信息
git remote -v
#添加远程仓库
git remote add  jianz77 https://github.com/jianz77/jianz77.git
#推送并更改到远程仓库
git push jianz77 master:11
#拉取远程仓库的更改    拉到最新
git pull jianz77 master:11
