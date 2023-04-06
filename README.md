# linux_env_settings
ubuntu linux环境的常用配置


## 文件列表:

-   `bashrc`:自定义的一套bash环境变量，优化shell界面打印信息，同时提供bash下的一些自定义命令;
-   `bash_aliases`:bash自定义命令配置文件，需要与.bashrc配合生效;
-   `code-conv.sh`:代码编码格式转换脚本;
-   `git-completion.bash`:git命令自动补全配置文件；
-   `gitconfig`:git的全局配置文件；
-   `vimrc`: vim编辑器的优化配置文件;(参考:https://github.com/ma6174/vim)

## 使用方法
将上述的所有文件复制到自己的home目录下，名字改为以.开头的形式，然后退出shell，再重新登录即可生效.

***注意：***

- ***所有的配置文件名是以".xxx"格式的隐藏文件***
- ***需要重新登录shell才能生效***


也可以通过运行脚本go.sh自动执行 
```
./go.sh
```

## 配置效果
配置文件copy到家目录下后效果如下：
```
smb@compiler-vm-ubuntu1604:~$ pwd
/home/smb
smb@compiler-vm-ubuntu1604:~$ ls -al
total 248K
drwxr-xr-x 20 smb  smb  4.0K Mar 16 15:10 .
drwxr-xr-x  4 root root 4.0K Jul 22  2022 ..
-rw-rw-r--  1 smb  smb   756 Mar 16 14:56 .bash_aliases
-rw-------  1 smb  smb   26K Feb 25 09:43 .bash_history
-rw-r--r--  1 smb  smb   220 Sep  1  2015 .bash_logout
-rw-r--r--  1 smb  smb  3.7K Sep  1  2015 .bashrc
drwx------ 13 smb  smb  4.0K Oct 18 15:26 .cache
drwx------ 14 smb  smb  4.0K Aug 29  2022 .config
-rw-rw-r--  1 smb  smb   60K Mar 16 14:56 .git-completion.bash
-rw-rw-r--  1 smb  smb   293 Mar 16 14:56 .gitconfig
drwxr-xr-x  2 smb  smb  4.0K Aug 29  2022 Music
drwxr-xr-x  2 smb  smb  4.0K Aug 29  2022 Pictures
-rw-r--r--  1 smb  smb   655 May 16  2017 .profile
drwxr-xr-x  2 smb  smb  4.0K Aug 29  2022 Public
drwx------  2 smb  smb  4.0K Aug 31  2022 .ssh
-rw-r--r--  1 smb  smb     0 Jul 23  2022 .sudo_as_admin_successful
drwxr-xr-x  2 smb  smb  4.0K Aug 29  2022 Templates
drwxr-xr-x  2 smb  smb  4.0K Aug 29  2022 Videos
drwxr-xr-x  2 smb  smb  4.0K Oct 31 09:25 .vim
-rw-------  1 smb  smb   19K Mar 16 15:10 .viminfo
-rw-rw-r--  1 smb  smb  2.6K Mar 16 14:56 .vimrc
```


## 自动为新创建的用户添加配置文件
root可以先将相关配置文件放到`/etc/skel`下，然后root创建的每个user的home目录就会自动包含这些配置文件.
