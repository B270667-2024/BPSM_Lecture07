#!/bin/bash

# 定义输入文件
input_file="example_people_data.tsv"

# 初始化变量
count=0
declare -A country_files  # 用于存储国家对应的文件
october_people=()         # 用于存储十月份出生的人

# 处理文件
while IFS=$'\t' read -r name email city birthday_day birthday_month birthday_year country; do
    # 跳过标题行和空行
    if [[ "$name" == "name" ]] || [[ -z "$name" ]]; then
        continue
    fi
    
    # 输出索引、姓名、城市和国家
    count=$((count + 1))
    echo "${count} : ${name}, ${city}, ${country}"
    
    # 将每个人按国家分文件存储
    if [[ ! -v country_files["$country"] ]]; then
        country_files["$country"]="file_${country// /_}.txt"  # 替换空格为下划线
    fi
    echo "${name}, ${city}, ${birthday_day}-${birthday_month}-${birthday_year}" >> "${country_files["$country"]}"

    # 检查是否在十月份出生
    if [[ "$birthday_month" == "10" ]]; then
        october_people+=("$name from $country")
    fi
done < "$input_file"

# 输出十月份出生的人
echo -e "\n十月份出生的人："
for person in "${october_people[@]}"; do
    echo "$person"
done

# 输出每个国家的十月份出生的人
echo -e "\n各国的十月份出生的人："
for country in "${!country_files[@]}"; do
    echo -e "\n在 ${country} 出生的人："
    grep "10" "${country_files["$country"]}" | while IFS=',' read -r name city birthday; do
        echo "姓名：$name, 城市：$city, 出生日期：$birthday"
    done
done

# 处理莫桑比克的数据
echo -e "\n莫桑比克的数据："
mozambique_people=()  # 用于存储莫桑比克的数据
while IFS=$'\t' read -r name email city birthday_day birthday_month birthday_year country; do
    if [[ "$country" == "Mozambique" ]]; then
        mozambique_people+=("$name, $city, $birthday_day-$birthday_month-$birthday_year")
    fi
done < "$input_file"

# 输出莫桑比克的数据
for person in "${mozambique_people[@]}"; do
    echo "$person"
done

