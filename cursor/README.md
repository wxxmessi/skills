# cursor — Cursor IDE 技能

存放给 Cursor Agent 使用的技能（SKILL.md 风格）。

## 文件命名

`<skill-id>.md`，全小写连字符。例：

- `sync-knowledge-to-github.md`
- `fix-canvas-runtime-error.md`
- `migrate-cursor-skill.md`

## 模板

```markdown
---
id: skill.cursor.<skill-id>
type: skill
host: cursor
tags: []
triggers:
  - ""
  - ""
visibility: public
version: 0.1.0
updated: YYYY-MM-DD
---

# <技能名>

## 何时用
（一句话，配 3-5 个用户口语 trigger 例子）

## 输入
- ……

## 步骤
1. ……
2. ……
3. ……

## 验证
（怎么知道做对了）

## 排错
（常见问题 → 解法表）

## 相关
- ……
```

## 在 Cursor 里激活

技能要被 Cursor 自动识别，需要 `~/.cursor/skills/` 指向本目录。一次性设置（管理员 PowerShell）：

```powershell
Remove-Item "$env:USERPROFILE\.cursor\skills" -Recurse -Force -ErrorAction SilentlyContinue
cmd /c mklink /J "$env:USERPROFILE\.cursor\skills" "E:\技能\cursor"
```

之后 Cursor Agent 会自动扫描这里的所有 `.md`。
