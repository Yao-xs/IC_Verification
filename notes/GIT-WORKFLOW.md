# 用 Git 记录学习

Git 保存本地版本；每次提交都是一个可比较的学习节点。本仓库暂不连接远程服务，本地提交也不会自动备份到云端。

## 每次学习结束

1. 复制 `notes/TEMPLATE.md` 为 `notes/YYYY-MM-DD.md`，记录目标、实验结果和未解决问题。
2. 保存代码，按 Ctrl+Shift+B 运行仿真，在日志写下真实结果。
3. 在 VS Code 按 Ctrl+Shift+G 打开源代码管理，点击文件查看差异。
4. 点击需要记录的文件旁的 `+` 暂存，输入描述并提交，例如 `learn: 验证计数器溢出行为`。

终端等价操作（在项目根目录）：

```powershell
git status
git diff
git add rtl tb notes
git diff --cached
git commit -m "learn: 验证计数器溢出行为"
git log --oneline --graph --decorate -15
```

若修改了任务、说明或编译文件列表，按需暂存 `.vscode`、`README.md`、`sim.f`、`scripts`。`git add` 是暂存；`git commit` 才创建版本。

## 查看过去的学习情况

```powershell
git log --oneline -- notes
git show HEAD
git diff HEAD~1 HEAD -- rtl tb
```

最后一条命令需要至少两次提交。

## 试验新想法

先提交当前进度，再建立练习分支：

```powershell
git switch -c exercise/counter-enable
# 完成实验并提交后，回到主分支
git switch main
# 需要保留实验时合并
git merge exercise/counter-enable
```

## 提交记录包含什么

记录 RTL、测试平台、脚本、配置和学习笔记。生成的 `build/`、VCD/FST 波形及安装包已忽略；需要比较的实验结果写入 Markdown 笔记。

仓库使用自己的署名设置。查看或更新：

```powershell
git config --local user.name
git config --local user.email
# 用你自己的实际信息替换下方示例
git config --local user.name "Your Name"
git config --local user.email "your-email@example.com"
```

修改署名仅影响之后的提交。以后要关联 GitHub 贡献记录，请使用账号已验证的邮箱或该账号设置页面给出的 noreply 邮箱。
