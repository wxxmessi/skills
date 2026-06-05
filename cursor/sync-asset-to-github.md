---
id: skill.cursor.sync-asset-to-github
type: skill
host: cursor
tags: [git, sync, windows, powershell]
triggers:
  - "同步知识库到 github"
  - "把 E:\\知识库 推送到 github"
  - "推送记忆 / 技能仓"
  - "sync foundry / memory-private / skills / private / invest-lab / redbook"
  - "把本地资产仓推送到 GitHub"
  - "备份个人 AI 数据中枢"
visibility: public
version: 0.2.0
updated: 2026-06-03
supersedes: skill.cursor.sync-knowledge-to-github
---

# 把本地资产仓同步到 GitHub（多仓通用）

把以下任一**本地资产仓 / 项目仓**推送到对应的 GitHub 远端。

## 目标仓清单

| 本地 | GitHub | 公私 |
|---|---|---|
| `E:\知识库` | `wxxmessi/foundry` | public |
| `E:\记忆` | `wxxmessi/memory-private` | private |
| `E:\技能` | `wxxmessi/skills` | public |
| `E:\技能-私人` | `wxxmessi/private` | private |
| `E:\投资Lab` | `wxxmessi/invest-lab` | private |
| `E:\投资Lab代码` | `wxxmessi/invest-lab-code` | private |
| `E:\小红书运营` | `wxxmessi/redbook` | private |

## 何时用

- 用户说"同步 / 推送 / 备份" + 任一上面仓
- 改完一批文件想 push
- 跨设备/网页编辑后需要 pull 远端再继续

## 环境约定

- Windows / PowerShell
- 各仓 `.git` 已初始化、`remote` 已配置、`main` 跟踪 `origin/main`
- 全局 `core.quotepath = false`（中文文件名显示正常）
- Git Credential Manager 已存好 GitHub 凭证

## 日常同步（90% 场景）

PowerShell 里 3 条命令：

```powershell
cd E:\<目标仓>          # 例如 E:\知识库 或 E:\记忆
git status              # 看看改了什么
git add .
git commit -m "更新: <一句话描述>"
git push
```

如果 `git status` 干净，啥也不用做。

**提交信息**写改了什么，不要写 "update"。AI 给建议时基于 `git diff` 出一句话。

## 拉取远端（多端协作时）

```powershell
cd E:\<目标仓>
git pull --rebase
```

如果本地有未提交变更：先 `git stash`，pull 完再 `git stash pop`。或者先 commit 再 pull。

## 首次设置（仅参考）

仅当某仓 `.git` 丢了或刚 clone 时才需要：

```powershell
cd E:\<目标仓>
git init
git remote add origin https://github.com/wxxmessi/<repo>.git
git config --global core.quotepath false
git fetch origin
git checkout -b main
git pull origin main --allow-unrelated-histories   # 仅首次
```

## 一键脚本

`scripts/sync-asset.ps1` 完成 status / add / commit / push：

```powershell
# 同步单个仓
powershell -ExecutionPolicy Bypass -File "E:\技能\cursor\scripts\sync-asset.ps1" -Path E:\知识库 -Message "更新: AI 调研"

# 不指定 Message 则用 "更新: yyyy-MM-dd HH:mm"
powershell -ExecutionPolicy Bypass -File "E:\技能\cursor\scripts\sync-asset.ps1" -Path E:\记忆

# 一键同步全部 6 个仓
powershell -ExecutionPolicy Bypass -File "E:\技能\cursor\scripts\sync-asset.ps1" -All
```

## 验证

`git push` 成功后输出：

```
To https://github.com/wxxmessi/<repo>.git
   <old>..<new>  main -> main
```

在网页确认 commit 出现：<https://github.com/wxxmessi/<repo>>

---

## 排错

### 1. `Permission denied` on `.git`

```
E:/<目标仓>/.git: Permission denied
```

原因：Windows 用户对该文件夹没写权限（常见于 `.git` 是 admin shell 建的）。

**管理员 PowerShell** 跑：

```powershell
icacls "E:\<目标仓>" /grant "$($env:USERNAME):(OI)(CI)F" /T
```

回普通 PowerShell 重试。同时确认 OneDrive / 坚果云 / 杀软 没锁住目录。

### 2. `! [rejected] main -> main (fetch first)`

远端比本地多了 commit（如 GitHub 上自动建的 README）。

```powershell
git pull origin main --allow-unrelated-histories   # 仅首次
git push -u origin main
```

后续 pull 用 `git pull --rebase` 就够了。

### 3. Vim 编辑器弹出来要 merge commit message

```
Merge branch 'main' of https://github.com/...
# Please enter a commit message...
```

退出 Vim：`Esc` → `:wq` → `Enter`。

要放弃 merge：`:cq` → `Enter`。

### 4. 第一次 push 弹认证

GitHub 不接受密码。两种方式：

- **推荐**：Git Credential Manager 弹窗选 "Sign in with your browser"，授权一次永久缓存
- **PAT**：<https://github.com/settings/tokens> 生 classic token（勾 `repo` scope），当密码用

### 5. 中文文件名显示成 `\344\274...`

```powershell
git config --global core.quotepath false
```

一次性，全局生效。

### 6. 大文件被拒（>100MB）

```powershell
git rm --cached <大文件路径>
echo <大文件路径> >> .gitignore
git add .gitignore
git commit -m "ignore large file"
```

或装 Git LFS（<https://git-lfs.com>）追踪。

### 7. remote URL 错了

```powershell
git remote -v
git remote set-url origin https://github.com/wxxmessi/<正确 repo>.git
```

### 8. 误 push 了 secret（API key / token）

**立刻**：

1. 去 GitHub Repo Settings → Secrets 或对应平台 revoke 那个 secret
2. 用 `git filter-repo` 或 BFG Repo-Cleaner 清历史
3. `git push --force` 覆盖远端
4. 在 `.gitignore` 里加上未来防同样情况

### 9. 撤销最后一次 commit（**未 push** 时安全）

```powershell
git reset --soft HEAD~1   # 保留改动
git reset --hard HEAD~1   # 丢弃改动（不可逆，谨慎）
```

---

## 相关

- 一键脚本：`E:\技能\cursor\scripts\sync-asset.ps1`
- 旧版（保留作历史）：`C:\Users\xixing.wang\.cursor\skills\sync-knowledge-to-github\` —— 单仓版，本技能是它的多仓升级版
- 设计文档：`C:\Users\xixing.wang\.cursor\projects\e\canvases\personal-ai-stack-design.canvas.tsx`
