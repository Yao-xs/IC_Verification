# IC Verification 学习环境

本目录已配置 Windows 原生 VS Code + Icarus Verilog + 波形查看器 + Codex。

## 立即开始

1. 用 VS Code 打开 `IC-Learning.code-workspace`，或打开整个 `D:\IV_ learning` 文件夹。
2. 阅读 `rtl/counter.sv`（设计）与 `tb/counter_tb.sv`（自检查测试平台）。
3. 保存修改后按 **Ctrl+Shift+B**，编译并仿真。正确输出为 `PASS: 25 checks`。
4. 打开 `build/counter.vcd`，使用 Surfer 查看波形；在信号列表选择并添加 `clk`、`rst_n`、`enable`、`count`。
5. 如需 GTKWave：通过菜单“终端 → 运行任务”选择 `Waveform: GTKWave (run simulation first)`，选中 `counter_tb` 下的信号并添加到波形区。

编译失败会停止执行，不会运行上次生成的仿真程序。测试发现不匹配会用 `$fatal` 返回失败。

## 终端使用

在本目录的新建 VS Code 终端执行：

```powershell
iverilog -V
vvp -V
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\simulate.ps1
```

等价的手动流程：

```powershell
New-Item -ItemType Directory -Force build
iverilog -g2012 -Wall -s counter_tb -o build/counter.vvp -f sim.f
# 仅当编译成功后运行下一行
vvp build/counter.vvp
gtkwave build/counter.vcd
```

工具目录：`D:\iverilog\bin`。已加入用户 PATH；现有终端可能需要关闭重开。当前工作区额外配置了终端 PATH，因此不依赖旧窗口继承的环境。

安装版本：Icarus Verilog 14.0 **开发快照**（Windows 发布包日期 2026-08-04）、GTKWave 3.3.128。它不是标记为稳定版的 Icarus 发行版本。本机计数器用例已实际通过 25 次检查并生成 VCD。

## Codex 在 VS Code 中使用

已安装 OpenAI 官方扩展 `openai.chatgpt`，其界面名称为 Codex。

1. 如果新扩展未出现，按 **Ctrl+Shift+P**，执行 `Developer: Reload Window`。
2. 按 **Ctrl+Shift+P**，执行 `Codex: Open Codex Sidebar`。
3. 若出现登录提示，使用你自己的 ChatGPT 账号完成浏览器登录。扩展已安装，但此次配置没有验证 IDE 的登录会话；桌面端登录不应被当作 IDE 已登录的证明。
4. 打开源文件或选中代码，用扩展的添加上下文功能把文件加入对话。

可直接尝试：

> 请用中文讲解 rtl/counter.sv 与 tb/counter_tb.sv，说明非阻塞赋值、时钟沿和复位的关系。先提问检查我的理解，再给我一道修改练习。

> 请在现有测试平台中加入复位释放后的检查，运行 scripts/simulate.ps1，解释每个新增检查覆盖什么行为。只使用当前 Icarus 支持的语法。

> 我遇到以下编译错误，请先区分是代码错误还是 Icarus 的 SystemVerilog 支持限制，再给出最小修复。

## 新建练习

- 设计放在 `rtl/`，测试平台放在 `tb/`；文件按模块名命名。
- 在 `sim.f` 中列出需要编译的源文件，包定义要排在使用它的文件之前。
- 默认顶层是 `counter_tb`。更换顶层时运行 `scripts/simulate.ps1 -Top your_tb`，或修改脚本默认值。
- 默认输出在 `build/`，波形文件名由测试平台的 `$dumpfile` 决定。新练习需同步调整波形任务的文件名。
- 保存时语法检查使用 Icarus；库查找路径已配置 `rtl` 和 `.sv`。复杂多文件工程以完整 `sim.f` 编译结果为准。
- 未安装外部格式化器和 Ctags，因此没有开启自动格式化和依赖 Ctags 的符号导航。

## 建议学习顺序与工具边界

1. **数字逻辑与 Verilog**：组合逻辑、时序逻辑、阻塞/非阻塞赋值、计数器、FSM、FIFO。
2. **基础验证**：激励、时钟复位、自检查 testbench、参考模型、边界测试与波形调试。
3. **SystemVerilog**：先使用本环境学习 `logic`、`always_ff`、任务/函数等支持的特性；逐项验证新增语法。
4. **高级验证与 UVM**：学习 class、约束随机、interface/virtual interface、SVA、功能覆盖率，再进入 transaction、driver、monitor、scoreboard、sequence 和 phase。

Icarus 的 SystemVerilog 支持仍不完整，`-g2012` 不代表完整实现该标准。本环境不能视为完整 UVM 仿真环境；仅下载 UVM 源码也无法补齐仿真器能力。进入第 4 阶段时，应接入具有相应 SV/UVM 支持和合法授权的仿真器，并针对实际版本验证课程用例。当前没有配置商业仿真器或许可证。

## Git 学习记录

每天复制 `notes/TEMPLATE.md` 写学习笔记，通过 VS Code 的源代码管理（Ctrl+Shift+G）提交代码与笔记。
完整操作见 [Git 学习记录流程](notes/GIT-WORKFLOW.md)。仿真产物和安装包不会加入版本记录。

## 参考资料

- [Icarus 官方安装说明](https://steveicarus.github.io/iverilog/usage/installation.html)
- [Icarus 语言开关与限制](https://steveicarus.github.io/iverilog/usage/command_line_flags.html)
- [Windows 发布包](https://bleyer.org/icarus/)
- [OpenAI 官方 Codex IDE 说明](https://learn.chatgpt.com/docs/codex/ide)
