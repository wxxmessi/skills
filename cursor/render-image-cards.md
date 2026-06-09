---
id: skill.cursor.render-image-cards
type: skill
host: cursor
tags: [出图, 图文卡, 小红书, 截图, html, 信息卡]
triggers:
  - "帮我生成小红书图片 / 图文卡"
  - "把这段内容/这张表做成图"
  - "出几张配图（分组表、赛程、盘点）"
  - "微博/抖音/B站封面图文"
  - "文字密集的卡片，AI 出图会糊"
visibility: public
version: 0.1.0
updated: 2026-06-09
---

# 文字卡出图（HTML → 截图）

把结构化文字内容（标题/列表/表格/数据）渲染成**平台尺寸的图片卡**：生成自包含 HTML，再用无头 Chrome/Edge 截图。中文/数字清晰，适合 AI 出图会糊的文字密集卡。

## 何时用
- 用户要把文案、表格、清单、数据做成可发布的图片 / 图文卡 / 配图。
- 内容文字多、要求准确（赛程、分组、盘点、对比、规则）——比 Seedream 之类生成式出图稳。
- 口语 trigger：「帮我生成两张截图」「把这表做成图」「出张小红书竖版」。

## 输入（让用户提供）
| 入参 | 必填 | 说明 |
|------|:--:|------|
| 场景 platform | ★ | 平台预设，定画幅/分辨率（见下表）。用户给「小红书竖版」即可 |
| 比例/尺寸 override | | 显式 `3:4`/`1:1`/`9:16`/`16:9` 或精确 `1080x1440`，覆盖场景默认 |
| 内容 content | ★ | 每张图一组：标题/副标题/正文(列表或表格)/页脚/高亮项；可多张 |
| 主题 theme | | `深色科技`(默认) / `品牌绿金` / `浅色简约`，或直接给主色 |
| 清晰度 scale | | 1/2(默认)/3 |
| 品牌/水印 | | 角落账号名或标签 |
| 输出 out | | 目录 + 文件名前缀；默认放当前内容档案的 `NN-配图/` |

最省事：只给 `场景 + 内容（+主题）`，其余取默认。

## 平台预设（1x 像素，截图时配 scale=2 更清晰）
| 场景 | 比例 | 尺寸 |
|------|------|------|
| 小红书竖版 | 3:4 | 1080×1440 |
| 小红书方版 / 微博 | 1:1 | 1080×1080 |
| 抖音 / 视频封面 | 9:16 | 1080×1920 |
| B站封面 | 16:9 | 1280×720 |
| 公众号头图 | 2.35:1 | 1080×460 |

## 主题（CSS 变量，套进模板的 `:root`）
- 深色科技（默认）：`--bg:#181818; --fg:#E4E4E4; --muted:#9a9a9a; --accent:#599CE7; --line:#262626; --hl:rgba(89,156,231,.14)`
- 品牌绿金（足球号）：`--bg:#0F3D2E; --fg:#F4F4F0; --muted:#BFD8CC; --accent:#E8C030; --line:rgba(255,255,255,.12); --hl:rgba(232,192,48,.16)`
- 浅色简约：`--bg:#FFFFFF; --fg:#1A1A1A; --muted:#6b7280; --accent:#2E79B5; --line:#ECECEC; --hl:rgba(46,121,181,.10)`

## 步骤
1. 由「场景」查预设表 → 得 Width/Height；用户给了 override 就用 override。
2. 选主题 → 取调色板填进模板 `:root`。
3. 每张图套一个**自包含 HTML**（内联 CSS，无外部资源），写到 `%TEMP%` 下的 ASCII 文件名（避免中文路径）。
4. 截图：`powershell -File "<junction>\scripts\screenshot.ps1" -Html <in.html> -Out <out.png> -Width <W> -Height <H> -Scale 2`
   脚本路径（个人 junction，ASCII）：`C:\Users\<用户>\.cursor\skills\scripts\screenshot.ps1`
5. 用读图工具检视效果；字号/边距不合适就调模板重出。
6. 多张内容循环 3–5；最后把 PNG 复制/移动到目标目录（中文目录用 `Move-Item`/`Copy-Item`，不要用 `git mv`）。

## HTML 模板（骨架，按需增删区块）
```html
<!DOCTYPE html><html lang="zh"><head><meta charset="utf-8"><style>
  :root{ --bg:#181818; --fg:#E4E4E4; --muted:#9a9a9a; --accent:#599CE7; --line:#262626; --hl:rgba(89,156,231,.14); }
  *{margin:0;padding:0;box-sizing:border-box}
  html,body{width:1080px;height:1440px}                 /* = Width×Height */
  body{background:var(--bg);color:var(--fg);font-family:"Microsoft YaHei","PingFang SC",sans-serif;
       padding:64px 60px;display:flex;flex-direction:column}
  .kicker{color:var(--accent);font-size:26px;font-weight:700;letter-spacing:2px}
  h1{font-size:58px;font-weight:800;line-height:1.15;margin-top:8px}
  .sub{color:var(--muted);font-size:30px;margin-top:14px}
  table{width:100%;border-collapse:collapse;margin-top:40px}
  th{text-align:left;color:var(--muted);font-size:26px;font-weight:600;padding:0 0 16px;border-bottom:1px solid var(--line)}
  td{font-size:31px;padding:18px 0;border-bottom:1px solid var(--line)}
  tr.hl td{background:var(--hl)}
  .foot{margin-top:auto;color:var(--muted);font-size:25px;line-height:1.5}
</style></head><body>
  <div class="kicker">小标题/品牌</div>
  <h1>主标题</h1>
  <div class="sub">副标题</div>
  <!-- 表格卡 / 列表卡 / 数据卡：按内容放 <table> 或 <div> 区块 -->
  <div class="foot">页脚 · 来源 · 水印</div>
</body></html>
```

## 截图脚本
`scripts/screenshot.ps1`：自动找 Chrome/Edge，经 `%TEMP%` ASCII 中转截图后移动到 `-Out`（支持中文输出目录）。
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\<用户>\.cursor\skills\scripts\screenshot.ps1" `
  -Html "C:\...\Temp\card.html" -Out "E:\...\配图\01.png" -Width 1080 -Height 1440 -Scale 2
```

## 验证
- 目标 PNG 存在且 >50KB；用读图工具打开核对：文字无截断/无乱码、画幅比例正确、高亮项对。

## 排错
| 现象 | 解法 |
|------|------|
| 找不到浏览器 | 安装 Chrome 或 Edge（Win10/11 自带 Edge） |
| 截图空白/失败 | HTML 引用了外部相对资源 → 图片改用 data URI 或绝对 `file://`；脚本已自动中转中文路径 |
| 文字溢出 | 调小字号 / 增大 padding，或内容拆成多张 |
| 底部留白多 | 内容比画幅短：加大字号/行距，或降低 Height；竖版可接受适当留白 |
| 边缘被裁 | 增大 body padding（安全边距），文案别贴边 |

## 相关
- 反向流程：`workflow/restore-doc-from-screenshot.md`（截图 → 文档）
- 资产同步到 GitHub：`cursor/sync-asset-to-github.md`
