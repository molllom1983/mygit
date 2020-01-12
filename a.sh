#!/bin/bash
#
watch_dir=/longshuai
push_to=fs.m
dest_mod=testrsync
rsync_auth_file=/etc/rsyncd.passwd1

inotifywait -mrq -e delete,close_write,moved_to,moved_from,isdir $watch_dir | \
# -e 指定监控事件如delete close_write attrib modify moved_from moved_to 
# -m 表示始终监控，否则只监控一次就退出
# -r 递归监控，监控目录包括目录下所有的子目录所有文件。这时如总文件数目要小于/proc/sys/fs/inotify/max_user_watches,
# -q --quiet的意思，不输出信息

while read line;do

  if echo $line | grep -i delete &>/dev/null; then

    echo "At `date +"%F %T"`: $line" >>/etc/delete.log

  else

#   rsync -az $line --password-file=$rsync_auth_file rsync://rsync_backup@$push_to:$dest_mod
    rsync -az $line $push_to::$dest_mod
# -a archive :归档模式，表示递归传输并保持文件属性。
# -z 压缩传输，提高效率

  fi

done
