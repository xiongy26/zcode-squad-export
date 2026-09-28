#!/usr/bin/env bash
# 探索者小队打包脚本：把本机【已安装】的小队配置重新打成 zcode-squad.tar.gz
# 打包源是 ~/.zcode/ 下的实际配置，所以改完配置无需手动同步到任何包目录。
# 用法：bash pack.sh [输出目录]（默认输出到当前目录）
set -e
out="${1:-.}"
mkdir -p "$out"

squad_dir="$HOME/.zcode/squad"
for need in "$HOME/.zcode/AGENTS.md" "$HOME/.zcode/探索者小队协作政策.md" "$squad_dir/install.sh" "$squad_dir/README.md" "$squad_dir/pack.sh"; do
  [ -e "$need" ] || { echo "缺少 $need —— 请先在本机运行过 install.sh 再打包"; exit 1; }
done
[ -d "$HOME/.zcode/agents" ] || { echo "缺少 ~/.zcode/agents —— 请先运行 install.sh"; exit 1; }

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
ex="$stage/zcode-squad-export"
mkdir -p "$ex/agents"
cp "$HOME/.zcode/AGENTS.md" "$ex/"
cp "$HOME/.zcode/agents/"*.md "$ex/agents/"
cp "$HOME/.zcode/探索者小队协作政策.md" "$ex/"
cp "$squad_dir/install.sh" "$squad_dir/pack.sh" "$squad_dir/README.md" "$ex/"
chmod +x "$ex/install.sh" "$ex/pack.sh"

tar -czf "$out/zcode-squad.tar.gz" -C "$stage" zcode-squad-export
count=$(ls "$HOME/.zcode/agents"/*.md | wc -l)
echo "已生成 $out/zcode-squad.tar.gz（含 $count 个成员定义）"
echo "分发到其他电脑：tar -xzf zcode-squad.tar.gz && cd zcode-squad-export && bash install.sh"
