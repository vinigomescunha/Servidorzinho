#!/bin/bash
echo -e "<h1>Index of ${query[dir]}</h1>"
echo -e "<small>Folder size: `du  --max-depth=0 -h ${query[file]} | awk '{print $1}'`</small><hr>"
echo -e "<div>`(ls -l  --file-type --format=single-column ${query[file]} | sort | while read fn ; do echo "<div class='icon  $([ "${fn:$((${#fn}-1)):1}" = "/" ] && echo 'dir' || echo 'file')'><a title='$fn' href=${query[dir]}/$fn><span>$fn</span></a></div>"; done)`</div><hr><i>`Servidorzinho.get_server_info`</i><hr>";
echo -e '<style>.icon{display:inline-block;width:70px;height:80px;margin:10px;position:relative;box-shadow:0 0 5px rgba(0,0,0,0.4);background:#ffffff;}.icon:hover{cursor:pointer;box-shadow:0 0 5px rgba(0,0,0,0.6);}.icon > a > span{bottom:0.5em;left:0px;width:100%;height:40%;position:absolute;color:#ffffff;text-align:center;text-shadow:0 0 1px rgba(0,0,0,0.6);word-break:break-all;display:flex;overflow:hidden;align-items:center;text-align:center;justify-content:center;}.icon.file > a > span{background:rgba(100,130,190,1);}.icon.dir > a > span{background:rgb(31, 72, 154);}.icon > a {color:#ffffff}</style>'

