#!/bin/sh

# 生成随机密码
GEN_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
echo "随机密码：${GEN_PASS}"

# 读取 SSH 端口和转发端口
read -e -p "请输入 SSH 端口: " ssh_port
read -e -p "请输入开始转发端口: " tran_port_start
read -e -p "请输入结束转发端口: " tran_port_end
read -e -p "CPU峰值,已转换为百分值: " cpu
read -e -p "分配内存值: " ram

# 替换 Dockerfile 中的密码
sed "s/{{ROOT_PASSWORD}}/$GEN_PASS/" Dockerfile > Dockerfile.tmp

# 构建 Docker 镜像
docker build -t debian$ssh_port -f Dockerfile.tmp .

# 启动 Docker 容器
docker run --name debian$ssh_port -p $ssh_port:22 -p $tran_port_start-$tran_port_end:$tran_port_start-$tran_port_end -d --restart always --cpus 0.$cpu --memory "$ram"m debian$ssh_port

# 删除临时文件
rm -f Dockerfile.tmp

echo "SSH端口: $ssh_port 密码: $GEN_PASS 端口: $tran_port_start - $tran_port_end OS:Debian" >> output.log
