---
aliases: [Icarus Verilog, iverilog使用]
tags: [Verilog, 工具, 仿真]
updated: 2026-10-15
---

# Icarus 环境与仿真流程

返回 [[00｜Verilog基础·学习地图]] · 下一篇 [[02｜设计方法与语言骨架]]

## 一、工具各自负责什么

| 工具 | 作用 | 输入与输出 |
|---|---|---|
| VS Code | 编辑、语法诊断、执行任务 | `.v`、`.sv`、项目配置 |
| `iverilog` | 预处理、编译与展开设计层次 | 源文件 → 默认 vvp 目标代码 |
| `vvp` | 运行编译结果 | `.vvp` → 终端信息与仿真波形 |
| Surfer / GTKWave | 查看信号随时间变化 | `.vcd` 等波形文件 |
| Git | 记录代码与笔记版本 | 文件修改 → 本地提交；push 后才同步远程 |

> [!important] 文件名与模块名分别使用
> `-o` 后跟输出文件名；`-s` 后跟**顶层模块名**。输出后缀由自己写，工具不会自动补 `.vvp`。

## 二、当前环境与迁移

本机已有 Icarus `14.0 (devel)`，工具目录为 `D:\iverilog\bin`。这是本机记录的开发快照，不将它当作最新稳定版推荐。

工作区是 `D:\IV_ learning`。VS Code 已配置 Verilog HDL、Surfer、Codex 扩展；`.vscode/settings.json` 保存语法检查、自动保存及终端路径，`.vscode/tasks.json` 保存运行任务。

另一台电脑应先安装或复用工具，再在项目根目录执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup-environment.ps1 -IcarusBin "D:\iverilog\bin" -InstallExtensions
```

脚本按本机路径调整项目设置并验证计数器，不代替工具安装；完整原始说明在工作区 `notes/ENVIRONMENT-RESTORE.md`。登录状态、工具程序和机器路径不会仅凭 Git 提交自动迁移。

## 三、标准操作流程

在项目根目录打开 PowerShell：

```powershell
iverilog -V
vvp -V
iverilog -g2012 -Wall -s tb_full_adder4 -o tb_full_adder4.vvp full_adder4.v tb_full_adder4.v
if ($LASTEXITCODE -eq 0) { vvp tb_full_adder4.vvp }
```

1. 保存源文件，确认设计和测试文件均在编译输入中。
2. 用 `-s` 明确选择 TB 顶层，避免无关根模块也被展开。
3. 编译成功后再运行，避免误看上一次生成的结果。
4. 先检查终端的 PASS/FAIL，再查看波形中的复位、激励与输出。

| 参数 | 含义 | 典型写法 |
|---|---|---|
| `-o` | 设置编译输出路径 | `-o build/test.vvp` |
| `-s` | 选择根模块 | `-s counter_tb` |
| `-g2005` | 使用 Verilog-2005 语言模式 | `-g2005` |
| `-g2012` | 使用 SystemVerilog-2012 语言模式 | `-g2012` |
| `-Wall` | 开启一组警告 | `-Wall` |
| `-f` | 读取编译文件列表 | `-f sim.f` |
| `-I` | 添加头文件搜索目录 | `-I include` |
| `-D` | 从命令行定义宏 | `-D DEBUG` |
| `-E` | 仅做预处理 | `-E -o expanded.v top.v` |
| `-V` / `-v` | 版本 / 详细编译信息 | 两者大小写不同 |

`-g2012` 不保证完整支持 SystemVerilog；遇到不支持的高级验证语法，先区分工具限制与代码错误。本环境不等于完整 UVM 仿真环境。

## 四、文件列表与一键任务

计数器所需的 `sim.f` 内容应为：

```text
rtl/counter.sv
tb/counter_tb.sv
```

它不是 HDL 源代码，而是编译输入清单：

```powershell
New-Item -ItemType Directory -Force build
iverilog -g2012 -Wall -s counter_tb -o build/counter.vvp -f sim.f
if ($LASTEXITCODE -eq 0) { vvp build/counter.vvp }
```

当前默认任务 `Ctrl+Shift+B` 调用 `scripts/simulate.ps1`，仍然依赖 `sim.f`。本次检查时工作区已经缺少该文件，运行默认脚本会报找不到命令文件。恢复上述列表后再用 `-f sim.f`；也可直接列出两个源文件编译。直接编译已验证计数器通过 25 项检查。

虽然直接列出源文件的命令不需要文件列表，但**在现有任务仍引用它时，删除它会使任务失效**。本次仅整理笔记，未代改原有脚本或恢复工程文件。

## 五、产生与查看波形

以下是 testbench 模块内片段：

```verilog
initial begin
    $dumpfile("tb_full_adder4.vcd");
    $dumpvars(0, tb_full_adder4);
end
```

`$dumpfile` 设置运行时波形文件；`$dumpvars(0, ...)` 从指定层次向下记录信号。执行 `vvp` 后才产生波形，路径相对仿真运行目录。

在 VS Code 打开 `.vcd` 用 Surfer 查看，或执行 `gtkwave tb_full_adder4.vcd`。当前脚本的计数器输出使用 `build/counter.vcd`。

## 六、已有错误的固定排查顺序

| 现象 | 优先排查 |
|---|---|
| `.vvp:1: syntax error` | 是否将编译结果又交给 `iverilog` 当源代码？ |
| `Unable to open input file` | `vvp` 文件名是否与 `-o` 完全一致？当前目录是否正确？ |
| `Unknown module type` | 是否遗漏定义该模块的源文件？是否误写模块类型？ |
| 大量递归层次错误 | 子模块内部是否错误例化了自身？ |
| 未出现波形 | 是否执行了 `vvp`，TB 中是否有 dump 指令？ |
| 仿真不结束 | 是否有 forever 时钟而缺少 `$finish` 或超时过程？ |

## 七、复习检查

- `iverilog -o abc test.v` 生成的是 `abc`，运行时应写什么？答：`vvp abc`。
- `-s tb` 中 `tb` 是源文件名还是模块名？答：模块名。
- 只有顶层 testbench、没有例化 DUT，能否仿真？答：能，顶层自身的过程也能执行。

命令细节依据 [Icarus 官方命令参数](https://steveicarus.github.io/iverilog/usage/command_line_flags.html) 与 [运行器参数](https://steveicarus.github.io/iverilog/usage/vvp_flags.html)。
