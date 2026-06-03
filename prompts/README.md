# prompts — Prompt 模板库

通用 prompt 资产，不绑定特定工具。分两层：

| 子目录 | 用途 |
|---|---|
| `personas/` | "你是一个 XXX 角色"——人格/身份预设 |
| `tasks/` | 任务模板（翻译、改写、代码 review、PRD、问答…） |
| `_TEMPLATE.md` | 写新 prompt 时复制此模板 |

## 命名

- personas: `<role>.md`，如 `senior-pm.md`、`code-reviewer-rust.md`
- tasks: `<verb>-<object>.md`，如 `translate-zh-en.md`、`review-prd.md`

## frontmatter

```yaml
---
id: skill.prompts.personas.senior-pm
type: prompt
host: universal
tags: [产品, 角色]
triggers:
  - "扮演高级产品经理"
visibility: public
version: 0.1.0
updated: YYYY-MM-DD
---
```

## 推荐结构

```markdown
# <prompt 名>

## 用法
（在哪个模型上用，复制粘贴还是 system message）

## 适用模型
- Claude Opus / Sonnet
- GPT-5
- DeepSeek V4
- Kimi K2

## Prompt
> 复制下面这段到 system / 对话开头：

```
<具体 prompt 内容>
```

## 输入要求
（用这个 prompt 时用户应该提供哪些信息）

## 输出形式
（期望的输出格式）

## 已知失效
（哪些模型/场景不适用、效果差）
```

## 设计原则

1. **可复用** — 不写一次性的 prompt 进来
2. **可参数化** — 用 `{{变量}}` 标注需要替换的部分
3. **可评估** — 至少给一个 "好输入 → 好输出" 的例子
