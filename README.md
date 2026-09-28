# 探索者小队配置包

把 ZCode 主会话变成"探索者小队"队长：主会话只拆解、派发、验收，子智能体成员分工实施。

## 内容

| 文件 | 安装到 | 作用 |
|---|---|---|
| `AGENTS.md` | `~/.zcode/AGENTS.md` | 每个新对话自动注入的队长指令（启用条件、八条铁律、成员速查表） |
| `agents/*.md` | `~/.zcode/agents/` | 成员定义（当前 6 个：Business-Analyst、architecture-design、coding、code-review、Escalation-Engineer、Mika），以目录内容为准，自动随增减变化 |
| `探索者小队协作政策.md` | `~/.zcode/` | 完整版政策（机制等价映射、派发模板、机制参数、不变量），AGENTS.md 引用它 |
| `install.sh` / `pack.sh` / `README.md` | `~/.zcode/squad/` | 安装与打包工具，供以后更新配置后重新打包 |

## 首次安装

前提：目标电脑已安装 ZCode。

```bash
tar -xzf zcode-squad.tar.gz && cd zcode-squad-export
bash install.sh
```

脚本会把目标机上已有的 AGENTS.md、agents 目录、squad 目录自动备份为 `.bak-时间戳` 再覆盖。

## 更新配置与重新打包

1. 在任意一台装有小队的电脑上直接编辑 `~/.zcode/` 下的配置（或在对话里让队长修改成员定义）。
2. 重新打包：`bash ~/.zcode/squad/pack.sh [输出目录]`，默认在当前目录生成 `zcode-squad.tar.gz`。打包源是 `~/.zcode/` 下的实际配置，改完即打，无需手动同步文件。
3. 把新包拷到其他电脑，解压后运行 `bash install.sh` 覆盖安装（同样会先备份旧配置）。

## 验证

新开一个 ZCode 对话，输入一句开发任务（如"做一个贪吃蛇网页游戏"）：

- 生效表现：主会话先确认玩法范围，然后派调研 → 架构 → 编码 → 审查，全程不亲自写代码，最后队长验收汇总。
- 未生效排查：确认文件已装入（`ls ~/.zcode/agents ~/.zcode/squad`），且对话是新开的（进行中的对话不会重新注入 AGENTS.md）。

## 注意

- 用户级配置，对该机所有工作区生效；只想在某项目启用时，把 AGENTS.md 内容挪到该项目的 `AGENTS.md` 即可。
- 若目标机已有自己的 AGENTS.md，脚本会覆盖它——从 `.bak-时间戳` 手工合并需要的原有内容。
- `~/.zcode/agents/` 里的所有 `.md` 都会被打包；如果某台机器上放了不想分发的私有智能体，打包前先移走或改扩展名。
