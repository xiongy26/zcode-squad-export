#!/usr/bin/env bash
# 探索者小队一键安装脚本：把小队配置装入本机用户级 ZCode 配置目录
set -e
cd "$(dirname "$0")"

ts=$(date +%Y%m%d-%H%M%S)

# 备份已有配置（如存在）
if [ -f "$HOME/.zcode/AGENTS.md" ]; then
  cp "$HOME/.zcode/AGENTS.md" "$HOME/.zcode/AGENTS.md.bak-$ts"
  echo "已备份原 AGENTS.md -> AGENTS.md.bak-$ts"
fi
if [ -d "$HOME/.zcode/agents" ]; then
  cp -r "$HOME/.zcode/agents" "$HOME/.zcode/agents.bak-$ts"
  echo "已备份原 agents 目录 -> agents.bak-$ts"
fi
if [ -d "$HOME/.zcode/squad" ]; then
  cp -r "$HOME/.zcode/squad" "$HOME/.zcode/squad.bak-$ts"
  echo "已备份原 squad 目录 -> squad.bak-$ts"
fi

# 安装
mkdir -p "$HOME/.zcode/agents" "$HOME/.zcode/squad"
cp AGENTS.md "$HOME/.zcode/AGENTS.md"
cp agents/*.md "$HOME/.zcode/agents/"
cp 探索者小队协作政策.md "$HOME/.zcode/探索者小队协作政策.md"
cp install.sh pack.sh README.md "$HOME/.zcode/squad/"
chmod +x "$HOME/.zcode/squad/install.sh" "$HOME/.zcode/squad/pack.sh"

echo ""
echo "安装完成："
ls "$HOME/.zcode/agents"/*.md
echo "新开一个 ZCode 对话即生效。用一句开发任务（如：做一个贪吃蛇网页游戏）验证主会话是否按小队流程派发。"
echo "以后修改了配置（直接编辑 ~/.zcode/ 下的文件），运行 bash ~/.zcode/squad/pack.sh [输出目录] 即可重新打包。"
