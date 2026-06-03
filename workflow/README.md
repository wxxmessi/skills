# workflow — 跨工具工作流 SOP

不依赖具体 AI 工具的"做事流程"，比如：

- 如何写一份 PRD（输入/产出/质量门）
- 如何做小红书选题与发布
- 如何做投资周复盘
- 如何处理一条客户反馈
- 如何上线一个 Side Project

这一层是**纯人类语言的 SOP**，AI 是配角，目的是让流程**可复现、可教**。

## 文件命名

`<动词-名词>.md`，例：

- `write-prd.md`
- `weekly-investment-review.md`
- `publish-xiaohongshu-post.md`

## 推荐结构

```markdown
---
id: skill.workflow.write-prd
type: skill
host: universal
tags: [PRD, 产品]
triggers:
  - "怎么写 PRD"
  - "PRD 模板"
visibility: public
version: 0.1.0
updated: YYYY-MM-DD
---

# 写一份 PRD

## 何时用
（什么场景下走这个 SOP）

## 输入
- 用户故事 / 需求来源
- 业务目标
- 时间窗

## 步骤
1. 用户问题陈述（1 句话）
2. 价值主张（3 句话）
3. 范围 / 不在范围
4. 关键流程图
5. 验收标准（DoD）
6. 风险与依赖

## 模板
> 直接抄改：

```
# <PRD 标题>
## 1. 问题
## 2. 价值
## 3. 范围
…
```

## 例子
（链到一个已经写完的 PRD 文件，活的样例）

## 不适用场景
- 实验性原型（先做 MVP，不写 PRD）
- 内部小工具（issue 描述清楚就行）
```
