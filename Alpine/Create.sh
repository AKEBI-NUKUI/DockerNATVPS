#!/bin/sh

ssh_port=$1
tran_port_start=$2
tran_port_end=$3
cpu=$4
ram=$5

# 生成随机密码
GEN_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
echo "随机密码：${GEN_PASS}"

# 读取 配置
if [ -z "$ssh_port" ]; then
  read -e -p "请输入小鸡SSH端口: " ssh_port
fi
if [ -z "$tran_port_start" ]; then
  read -e -p "请输入开始转发端口: " tran_port_start
fi
if [ -z "$tran_port_end" ]; then
  read -e -p "请输入结束转发端口: " tran_port_end
fi
if [ -z "$cpu" ]; then
  read -e -p "CPU峰值,已转换为百分值，直接输入50，则为50%: " cpu
fi
if [ -z "$ram" ]; then
  read -e -p "分配内存MB: " ram
fi

# 替换 Dockerfile 中的密码
sed "s/{{ROOT_PASSWORD}}/$GEN_PASS/" Dockerfile > Dockerfile.tmp

# 构建 Docker 镜像
docker build -t alpine$ssh_port -f Dockerfile.tmp .

# 启动 Docker 容器
docker run --name alpine$ssh_port -p $ssh_port:22 -p $tran_port_start-$tran_port_end:$tran_port_start-$tran_port_end -d --restart always --cpus 0.$cpu --memory "$ram"m alpine$ssh_port

# 删除临时文件
rm -f Dockerfile.tmp

echo "SSH端口: $ssh_port 密码: $GEN_PASS 端口: $tran_port_start - $tran_port_end OS:Alpine" >> output.log
