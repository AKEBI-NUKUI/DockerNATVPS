#!/bin/bash

clear
echo "####################################################################################################"
echo -e "#                         让AKEBI-NUKUI帮你一键批量生出Docker NAT小鸡（Alpine）                    #"
echo -e "#                                   Create By AKEBI-NUKUI                                          #"
echo "####################################################################################################"

# 设置第一个容器的 SSH 端口和需要的转发端口数量
read -e -p "告诉我你想生多少只小鸡: " count
read -e -p "请输入第一只小鸡的SSH端口号: " ssh_port
read -e -p "请输入每只小鸡需要转发的端口数: " port_num
read -e -p "请输入每只小鸡占用CPU百分比 [默认值25]: " cpu
cpu=${cpu:-25}
read -e -p "请输入每只小鸡内存MB [默认值64]: " ram
ram=${ram:-64}

for i in `seq 1 $count`
do 
  # 新建LXC容器
  nat_start=$((ssh_port + 1))
  nat_end=$((nat_start + port_num - 1))
  
  echo "正在创建Alpine${ssh_port}小鸡，转发端口：$nat_start-$nat_end"
  
  ./Create.sh $ssh_port $nat_start $nat_end $cpu $ram
  
  # 递增下一个容器的 SSH 端口和需要的转发端口数量
  ssh_port=$((nat_end+1))
done

echo "批量创建Alpine Over Docker小鸡已完成。"
