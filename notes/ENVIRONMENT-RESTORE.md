# 在另一台 Windows 电脑恢复环境

本仓库保存项目配置、扩展推荐、仿真脚本和学习代码。工具安装程序、账户登录、Codex 聊天记录和用户级技能不属于此备份。

## 给另一台电脑的 Codex 的指令

复制下面这段话，并提供本仓库地址或先打开克隆后的文件夹：

> 请按 notes/ENVIRONMENT-RESTORE.md 恢复此仓库的 Windows + VS Code + Icarus Verilog 学习环境。先检查已安装的 Git、Icarus、VS Code 和推荐扩展，复用现有安装。使用 scripts/setup-environment.ps1 配置本机路径并安装推荐扩展，运行计数器测试，确认输出 PASS: 25 checks 且生成 build/counter.vcd。保留我的代码和现有用户设置。如需安装缺失工具，从官方发布渠道获取。最后告诉我如何编译 runoob.v 和查看波形。

## 恢复步骤

1. 安装或复用 Git、VS Code、Icarus Verilog；将 Git 加入 PATH。Icarus 参考版本为本机的 14.0 开发版，不要求覆盖另一台电脑已可用的版本。
2. 克隆仓库，用 VS Code 打开 `IC-Learning.code-workspace`。
3. 在项目根目录运行（按实际位置修改路径）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup-environment.ps1 -IcarusBin "D:\iverilog\bin" -InstallExtensions
```

脚本会验证工具、更新项目中的路径、安装 `.vscode/extensions.json` 推荐的扩展并运行计数器测试。不下载工具，不修改系统 PATH。若 Icarus 已在 PATH 或标准位置，可省略 `-IcarusBin`。

4. 重新加载 VS Code 并新建终端。按 Ctrl+Shift+B 应输出 `PASS: 25 checks`。打开 `build/counter.vcd` 使用 Surfer 查看波形。GTKWave 为可选工具，只有已安装时才使用对应任务。
5. Codex 扩展的账户登录在本机完成。

## 保存的编辑体验

- 停止输入 1 秒后自动保存。
- Verilog/SystemVerilog 文件关联，4 空格缩进。
- Icarus 语法检查，SystemVerilog 2012，`rtl` 库搜索路径。
- Ctrl+Shift+B 编译并运行计数器自检查测试。
- Surfer 打开 VCD；资源管理器隐藏 `.vvp` 文件。
- 推荐扩展：`mshr-h.VerilogHDL`、`surfer-project.surfer`、`openai.chatgpt`。

参考扩展版本（2026-10-11 本机目录观察，非锁定版本）：Verilog HDL 1.29.0、Surfer 0.7.1001488。扩展清单按 ID 安装可用版本。

## 两台电脑的日常同步

开始学习前 `git pull`；结束后提交代码和笔记并 `git push`。环境恢复脚本产生的本机路径差异在提交前检查，避免另一台电脑直接沿用错误路径；切换电脑时可重新运行恢复脚本。

仿真产物 `build/`、`*.vvp`、`*.vcd`、`*.fst` 已被忽略，在目标电脑重新生成：

```powershell
iverilog -o runoob.vvp runoob.v
if ($LASTEXITCODE -eq 0) { vvp runoob.vvp }
```

`runoob.v` 通过 `$dumpfile` 和 `$dumpvars` 在运行时生成 `runoob.vcd`。
