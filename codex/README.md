# codex — Codex CLI 技能与配置

存放 Codex CLI 用的配置文件、custom instructions、自定义 agent。

## 适合放什么

- `instructions/` — 写给 Codex 的 system instructions（按主题切分）
- `config-templates/` — 不含 API key 的 `config.toml` 模板（如 deepseek、kimi、openrouter）
- `agents/` — `AGENTS.md` 样板（针对某类项目）

## 命名

- instructions: `<主题>.md` 如 `frontend-review.md`、`investment-research.md`
- config 模板: `config.<provider>.template.toml`
- agents: `AGENTS.<scenario>.md`

## frontmatter

```yaml
---
id: skill.codex.<name>
type: skill
host: codex
tags: []
triggers: []
visibility: public
version: 0.1.0
updated: YYYY-MM-DD
---
```

## 使用方式

### 让 Codex 引用 instruction

在 `~/.codex/instructions.md` 里加：

```markdown
@import E:\技能\codex\instructions\<name>.md
```

或者在某个项目的 `AGENTS.md` 里 reference。

### 套用 config 模板

```powershell
Copy-Item E:\技能\codex\config-templates\config.deepseek.template.toml `
          $env:USERPROFILE\.codex-deepseek\config.toml
# 然后手动填 auth.json 里的 API key
```

## 注意

**绝不放 API key 进任何文件**。模板里所有 secret 用 `<FILL_ME>` 占位。
