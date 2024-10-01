#!/usr/bin/awk -f
BEGIN {
    FS="\t"; OFS="_";
    count = 0;        # 初始化计数器
    total = 0;       # 初始化总和
}

{
    count++;

    if ($1 != "#") {  # 去掉反斜杠
        print "Currently doing " count;
        total = total + ($12 * $3);  # 去掉反斜杠
    }
}

END {
    print "The total for " count " lines was " int(total) > "awkoutputfile.txt";  # 生成输出文件
    print "Script run complete." >> "awkoutputfile.txt";  # 追加内容
    print "Script run complete.";
    system("ls -alrt *awk*");  # 列出所有awk文件
}


