---
id: skill.workflow.personal-ai-stack
type: skill
host: universal
tags: [架构, 个人系统, 资产桶, 跨设备, 跨工具]
triggers:
  - "怎么用我的个人 AI 数据中枢"
  - "知识 / 记忆 / 技能放哪里"
  - "新建一个项目目录的规范"
  - "frontmatter 怎么写"
  - "AI 工具读哪些桶"
visibility: public
version: 1.0.0
updated: 2026-06-03
---

# 个人 AI 数据中枢 · 使用手册

> 一份"我应该把这个东西放哪、用什么格式、被哪个工具读到、什么时候清理"的实操指南。

设计原则见 ADR：[`memory/decisions/2026-06-03-个人AI栈重构.md`](../../记忆/decisions/2026-06-03-个人AI栈重构.md) · 设计画布：`personal-ai-stack-design.canvas.tsx`

---

## 1 · 完整目录结构

### 1.1 顶级地图

```
E:\
├── 知识库\        → wxxmessi/foundry              (public)   外部研究/方案/教材
├── 记忆\          → wxxmessi/memory-private       (private)  我是谁、决策、画像
├── 技能\          → wxxmessi/skills               (public)   SOP、prompt、工具配置
├── 技能-私人\     → wxxmessi/private              (private)  含敏感上下文的技能
├── 投资Lab\       → wxxmessi/invest-lab           (private)  项目（完整工作台）
└── 投资Lab代码\   → wxxmessi/invest-lab-code      (private)  项目（代码部分）
```

### 1.2 资产桶内部

```
E:\知识库\
├── 企业知识智能化管理\
├── 呼叫中心知识体系\
├── 标签体系设计\
└── 创业规划\               # 注：后续可能改名为 运营方案\
    ├── AI生成PRD\
    ├── 呼叫中心与对话机器人方案\
    ├── 个人IP_内容变现方案.md
    └── 小红书*.md

E:\记忆\
├── profile\        # 个人画像（身份、目标、风格、偏好、家庭、健康）
├── decisions\      # ADR 风格决策记录（YYYY-MM-DD-<主题>.md）
└── career\         # 简历、面试准备、岗位调研

E:\技能\
├── cursor\         # Cursor IDE skills（SKILL.md 格式）
│   ├── sync-asset-to-github.md
│   └── scripts/sync-asset.ps1
├── codex\          # Codex CLI instructions/config 模板
├── workflow\       # 跨工具 SOP（本文档在这里）
└── prompts\
    ├── personas\   # 角色预设
    ├── tasks\      # 任务模板
    └── _TEMPLATE.md
```

### 1.3 项目目录的推荐骨架

未来新建项目时（例如"小红书账号运营"），目录结构参考：

```
E:\小红书\
├── README.md                   # 项目目标、KPI、当前阶段
├── INDEX.json                  # 元数据
├── .gitignore
├── 00-计划与决策\              # 项目内"小记忆"（项目级 ADR）
├── 10-内容库\                  # 已发布/草稿
├── 20-数据\                    # KPI、报表
├── 30-SOP\                     # 项目内的小技能
├── 40-素材\                    # 图片、视频、模板
└── 99-归档\                    # 失败实验、过期内容
```

数字前缀借自 PARA / Johnny Decimal 风格，便于排序与扩展。

---

## 2 · Frontmatter 规范

每个 `.md` 顶部加 YAML frontmatter，用于未来 `INDEX.json` 自动生成与 AI 工具的语义检索。

### 2.1 知识（`知识库/`）

```yaml
---
id: knowledge.<topic>.<short-name>
type: research | guide | spec | overview
tags: [RAG, 企业知识]
visibility: public
version: 0.1.0
updated: 2026-06-03
---
```

`type` 取值参考：
- `research`：行业/技术调研报告
- `guide`：方法论 / 教程
- `spec`：方案设计 / PRD / 架构文档
- `overview`：综述 / 导读

### 2.2 记忆（`记忆/`）

#### 2.2.1 决策（`decisions/`，最重要）

```yaml
---
id: memory.decisions.2026-06-03-stack-redesign
type: decision
tags: [架构, 个人系统]
status: exploring | decided | revisited | reversed
visibility: private
created: 2026-06-03         # 决策发生时间
updated: 2026-06-03         # 最后修订时间
related:
  - canvas: <path>
  - decision: <id of related ADR>
---
```

#### 2.2.2 画像（`profile/`）

```yaml
---
id: memory.profile.identity
type: profile
tags: [身份, 长期]
visibility: private
updated: 2026-06-03
---
```

#### 2.2.3 职业（`career/`）

```yaml
---
id: memory.career.interview.bytedance-2026-06
type: interview-prep | resume | job-research | reflection
tags: [字节, 系统设计]
status: prepared | done | follow-up
visibility: private
updated: 2026-06-03
---
```

### 2.3 技能（`技能/`、`技能-私人/`）

```yaml
---
id: skill.<host>.<name>                       # 公开仓
id: skill.private.<host>.<name>               # 私人仓
type: skill
host: cursor | codex | cherry-studio | obsidian | universal
tags: [git, sync]
triggers:                                     # ≥ 3 条不同表述，AI 用它决定激活
  - "同步知识库到 github"
  - "把 E:\\记忆 推送到云端"
  - "推送个人资产仓"
visibility: public | private
version: 0.2.0
updated: 2026-06-03
supersedes: <旧 id>                            # 可选，标记升级关系
---
```

### 2.4 Prompt（`技能/prompts/`）

```yaml
---
id: skill.prompts.<category>.<name>
type: prompt
host: universal
tags: [角色, 产品]
triggers:
  - "扮演高级产品经理"
适用模型:                                     # 可写非英文 key（YAML 支持）
  - claude-opus
  - gpt-5
  - deepseek-v4
visibility: public
version: 0.1.0
updated: 2026-06-03
---
```

### 2.5 项目根 INDEX.json

```json
{
  "version": "1.0.0",
  "type": "project",
  "name": "小红书账号运营",
  "status": "active | paused | archived",
  "started": "2026-07-01",
  "kpi": {
    "粉丝目标": 3000,
    "月收入目标": 5000
  },
  "owner": "wxxmessi",
  "updated": "2026-06-03"
}
```

---

## 3 · 各工具投递规则

### 3.1 读取规则（每个工具应该看哪些桶）

| 工具 | 知识库 | 记忆 | 技能（公开）| 技能-私人 | 项目 |
|---|---|---|---|---|---|
| **Cursor**（写代码 / 做项目） | ✓ 项目引用 | ✗ | ✓ `cursor/` 自动激活 | ✗ 除非项目需要 | ✓ 当前项目 |
| **Cursor**（chat 通用问答） | ✓ | △ 手动 @ 提及 | ✓ | △ | ✗ |
| **Codex CLI** | ✓ | △ `~/.codex/instructions.md` 引入时 | ✓ `codex/` 用作 instructions | △ | △ |
| **Cherry Studio** / 桌面 AI 客户端 | △ 手动选 | ✗（隐私）| ✓ 复制 prompts | ✗ | ✗ |
| **Obsidian**（vault 模式） | ✓ vault | ✓ 私 vault | ✓ | ✓ | ✗ |
| **Continue / Cline** | ✓ | ✗ | ✓ | △ | ✓ |
| **ChatGPT / Claude 网页** | 手动复制粘贴 | ✗ | 手动复制 prompts | ✗ | ✗ |

> 标记说明：✓ = 默认应该读 / △ = 按需 / ✗ = 不读

### 3.2 写入规则（产物去哪里）

| 我刚产出的东西 | 应该去哪 |
|---|---|
| AI 调研出来的新方案 / 文献笔记 | `知识库/<主题>/` |
| 一次重要决策的"为什么" | `记忆/decisions/YYYY-MM-DD-<主题>.md` |
| 个人画像 / 偏好更新 | `记忆/profile/<topic>.md` |
| 跳槽 / 面试材料 | `记忆/career/<子目录>/` |
| 一个好用的 prompt | `技能/prompts/<category>/<name>.md` |
| 工作流 SOP（写 PRD、做复盘）| `技能/workflow/<name>.md` |
| Cursor 用的技能 | `技能/cursor/<name>.md` |
| Codex 的 instructions | `技能/codex/instructions/<name>.md` |
| 含客户名/真实公司名的技能 | `技能-私人/<host>/<name>.md` |
| 项目内反复用的脚本 / SOP | `<项目>/30-SOP/`（成熟后再提升到 `技能/`）|
| 项目内的战略决策 | `<项目>/00-计划与决策/` 或 `记忆/decisions/`（看影响范围）|
| API key / 密码 | **永远不入任何 git 仓**，用密码管理器 |

### 3.3 写入时一个判断流程

```
这条内容是关于我自己的吗？
├─ 是 → 记忆桶
│       ├─ 关于身份/偏好 → profile/
│       ├─ 关于决策 → decisions/
│       └─ 关于职业 → career/
└─ 否（是对外可分享的）
    ├─ 是一段静态参考资料 → 知识库
    ├─ 是一个可重复执行的动作/模板 → 技能
    │   ├─ 含敏感信息 → 技能-私人
    │   └─ 不含敏感信息 → 技能
    └─ 是一个有目标有起止的工作 → 新建项目顶级目录
```

---

## 4 · 4 种典型坑（必读）

### 坑 1 · 在 GitHub 上勾了仓库初始化选项

**症状**：本地首次 `git push` 报 `! [rejected] main -> main (fetch first)`。

**原因**：新建 repo 时勾选了 README / .gitignore / license，导致远端已有 commit，本地无法 fast-forward。

**预防**：建仓时 **空仓 + 不勾任何初始化选项**。

**补救**：
- 远端只有 GitHub 自动 README 时：`git push -u origin main --force`
- 远端有真实内容时：`git pull origin main --allow-unrelated-histories` 再 push

### 坑 2 · 把项目硬塞进资产桶

**症状**：知识库里出现一个完整项目（如"投资Lab"），里面又有知识 + 决策 + 代码索引 + 日志，整个目录像缩小版的个人系统。

**原因**：把"项目"误当成"资产桶里的一个主题"。

**预防**：判别法——

| | 资产 | 项目 |
|---|---|---|
| 时间属性 | 长期沉淀 | 有目标有起止 |
| 内部组成 | 单一类型（要么纯研究、要么纯 SOP）| 多类型混合 |
| 是否需要持续运营 | 否 | 是 |

如果以上 2/3 项指向"项目"，**提为独立顶级目录**。

**补救**：用今天 B 类迁移的步骤——`Move-Item` + 新仓 init + 旧位置 `git rm -r`。

### 坑 3 · 隐私内容误进公开仓

**症状**：写完一个 prompt 模板，里面带了真实公司名 / 客户代号 / 个人手机号，已经 push 到 `wxxmessi/skills`（public repo）。

**原因**：写技能时没有先决定"它放公开还是私人"。

**预防**：
- 写每个文件**前**先想 frontmatter 的 `visibility` 字段，并据此决定**仓库位置**
- 公开仓推前 `git diff` 过一遍敏感词
- 配合 `.gitignore` 把 `*.private.*` `*-secret.*` 排掉

**补救**（**立刻执行**）：
1. 如涉及 API key / token → **先去对应平台 revoke**，再做下面任何 git 操作
2. 把文件移到 `技能-私人/` 仓并 commit
3. 公开仓里用 `git filter-repo` 或 BFG 清历史
4. `git push --force` 覆盖远端
5. 加到 `.gitignore` 防止再犯

### 坑 4 · PowerShell 复制粘贴坑（中文 / 多行）

**症状**：
- 多行命令粘贴后变成一行：`New-Item ... | Out-Nullnotepad ...` 拼接报错
- `.ps1` 脚本含中文，运行报"未识别的标记"
- 长字符串里的反引号被吃掉，转义失效

**原因**：
- Windows 终端对多行 paste 处理不一致（旧 console 尤其差）
- PowerShell 5.1 默认 GBK 编码读 `.ps1`，中文 UTF-8 文件需要 BOM 才能正确解析
- 富文本粘贴会改 quote 字符（"" → "" /""）

**预防**：
- 多行命令拆成单行执行，或写成 `.ps1` 脚本再调用
- `.ps1` 含中文统一存 **UTF-8 with BOM**（脚本里加 `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8`）
- 优先用 **Windows Terminal**（不要用 cmd.exe 旧 console）
- 复杂命令用 Notepad / VS Code 编辑后 .ps1 执行，不靠粘贴

**补救**：
- 一行命令报错就拆成几行
- 中文乱码就 `chcp 65001` + 设 OutputEncoding
- 脚本 BOM 化：`$content = Get-Content $f -Raw -Encoding UTF8; [System.IO.File]::WriteAllText($f, $content, (New-Object System.Text.UTF8Encoding $true))`

---

## 5 · 90 天节奏（与 ADR review 配套）

### Week 1（首周观察期）

- [ ] 每天结束**记一下"新内容放进了哪个桶"**——找不顺手的边界
- [ ] 装管理员 PS 跑一次 `mklink junction`，让 Cursor 自动看到 `E:\技能\cursor\`
- [ ] 跑一次 `sync-asset.ps1 -All` 验证多仓脚本

### Week 2-4（第一批资产建立）

- [ ] `技能/prompts/` 沉淀 5 条最常用 prompt（含 personas 和 tasks 各 2-3）
- [ ] `技能/workflow/` 写 3 个 SOP（除本文档外，建议：写 PRD、做项目复盘、上线一个 Side Project）
- [ ] `记忆/profile/` 至少补 `identity.md` + `personal-style.md` + `tool-stack.md`
- [ ] 每周末检查：`git status` 是否干净？有没有忘了 push 的 commit？

### Month 2

- [ ] 评估 `创业规划/` 目录命名（是否改为 `运营方案/`）
- [ ] `记忆/decisions/` ≥ 5 条 ADR（包括过往重要决策的补录）
- [ ] 开始写 INDEX 自动生成脚本（扫各仓 frontmatter → 写 INDEX.json）
- [ ] 在第二台设备（公司电脑 / Mac）完整 clone 一遍 6 仓，记录用时与卡点

### Month 3

- [ ] 项目数评估：如果活跃项目 ≥ 5 个，考虑收编到 `项目\` 二级目录
- [ ] 跨工具实测：用 Cherry Studio / Obsidian 各开一次，对比读取体验
- [ ] 第一次 `decisions/` 集中复盘——已有的决策有没有 `revisited` / `reversed` 的？

### Month 6

- [ ] MCP 化探索：把任一资产仓做成 MCP server，看 Claude Desktop / Cursor 能不能消费
- [ ] 隐私审计：`技能/` 和 `知识库/` 全仓 grep 敏感词（公司名、手机号、内部代号）
- [ ] 整套架构是否仍然合理？写下一份 ADR 续篇

---

## 6 · 常用命令速查

### 单仓同步

```powershell
cd E:\<仓>
git status
git add .
git commit -m "<改了什么>"
git push
```

### 一键同步全部 6 仓

```powershell
powershell -ExecutionPolicy Bypass -File "E:\技能\cursor\scripts\sync-asset.ps1" -All
```

### 拉取远端最新（多端协作前）

```powershell
git -C E:\<仓> pull --rebase
```

### 新建一条记忆决策

```powershell
$today = Get-Date -Format "yyyy-MM-dd"
$topic = "某主题"
notepad "E:\记忆\decisions\$today-$topic.md"
# 在 notepad 里粘贴模板（参考 E:\记忆\decisions\README.md）
```

### 新建一个技能

```powershell
$id = "my-new-skill"
Copy-Item "E:\技能\prompts\_TEMPLATE.md" "E:\技能\cursor\$id.md"
notepad "E:\技能\cursor\$id.md"
```

### 检查所有仓状态

```powershell
foreach ($d in @("E:\知识库","E:\记忆","E:\技能","E:\技能-私人","E:\投资Lab","E:\投资Lab代码")) {
    Write-Host "=== $d ===" -ForegroundColor Cyan
    git -C $d status --short
}
```

---

## 7 · 相关

- **ADR**：`E:\记忆\decisions\2026-06-03-个人AI栈重构.md`（决策的"为什么"）
- **设计画布**：`C:\Users\xixing.wang\.cursor\projects\e\canvases\personal-ai-stack-design.canvas.tsx`（视觉版）
- **同步技能**：`E:\技能\cursor\sync-asset-to-github.md`（操作的"怎么做"）
- **同步脚本**：`E:\技能\cursor\scripts\sync-asset.ps1`
- **各桶 README**：`E:\<桶>\README.md`（每桶的具体写作约定）

---

> 这是 v1.0.0。本文件作为唯一事实源，与各桶 README、ADR、画布同步演进。任何边界规则变更先写进这里，再回流到其它文档。
