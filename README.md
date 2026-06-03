# 技能（公开）/ Skills (Public)

我的"私人 AI 数据中枢"三大资产桶之一——**可复用的动作/流程/模板**。

| 桶 | 内容 | 仓库 |
|---|---|---|
| 知识库 | 外部参考资料 | `wxxmessi/foundry` |
| 记忆 | 个人画像/决策 | `wxxmessi/memory-private` (private) |
| **技能（公开，本仓）** | **可分享的 SOP、prompt、工具配置** | `wxxmessi/skills` (public) |
| 技能（私人） | 含敏感上下文的技能 | `wxxmessi/private` (private) |

## 技能 vs 知识 vs 记忆

| | 技能 | 知识 | 记忆 |
|---|---|---|---|
| 形式 | 动词、可执行 | 名词、可阅读 | 历史快照 |
| 例子 | "怎么发小红书"SOP / Cursor 自定义 rule | RAG 架构调研 | 我的简历 |
| 复用 | 跨项目反复用 | 偶尔查阅 | 个人独有 |
| 公开度 | 高（脱敏后）| 中-高 | 极低 |

## 目录结构

```
E:\技能\
├── cursor\          # Cursor IDE 用的技能（SKILL.md 格式）
├── codex\           # Codex CLI 配置 / 自定义 instructions
├── workflow\        # 跨工具的工作流 SOP（"如何写 PRD"、"如何复盘交易"）
└── prompts\         # 通用 prompt 模板（personas、tasks）
```

## 一个"技能"是什么

最小单位是 **一个 `.md` 文件**，包含：

1. **frontmatter**（机器读）
2. **何时触发**（一句话）
3. **怎么用**（步骤 / 示例 / 模板）
4. （可选）**配套文件**（脚本、配置、参考）

模板见 `prompts/_TEMPLATE.md` 或下方示例。

## frontmatter 规范

```yaml
---
id: skill.cursor.sync-knowledge-to-github
type: skill
host: cursor             # cursor | codex | cherry-studio | obsidian | universal
tags: [git, sync]
triggers:
  - "把本地知识库同步到 github"
  - "推送知识库变更"
visibility: public
version: 0.1.0
updated: 2026-06-03
---
```

`triggers` 字段重要——这是 AI 工具决定"该不该激活这个技能"的依据。**写得越具体越好**，至少 3 条不同表述。

## 怎么用（多端）

### 在 Cursor 里

把 `E:\技能\cursor\` 通过 junction/symlink 链到 `~/.cursor/skills/`（一次设置）：

```powershell
# 管理员 PowerShell
Remove-Item "$env:USERPROFILE\.cursor\skills" -Recurse -Force -ErrorAction SilentlyContinue
cmd /c mklink /J "$env:USERPROFILE\.cursor\skills" "E:\技能\cursor"
```

之后所有 cursor/ 目录下的技能 Cursor 自动识别。

### 在 Codex 里

把相关技能 import 进 `~/.codex/instructions.md`，或在每个项目的 `AGENTS.md` 里 reference。

### 在其他工具里

复制粘贴对应 prompt 即可。后续 MCP 化后会统一。

## 同步

```powershell
cd E:\技能
git add -A
git commit -m "<增/改了什么技能>"
git push
```

公开仓——**写之前先脱敏**。要带个人/客户/公司信息的技能，放 `E:\技能-私人\`。

## 相关

- 设计文档：`C:\Users\xixing.wang\.cursor\projects\e\canvases\personal-ai-stack-design.canvas.tsx`
- 私人技能仓：`E:\技能-私人\`
