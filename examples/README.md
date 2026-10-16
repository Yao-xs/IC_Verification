# Verilog 案例速查

所有设计和测试文件直接放在本文件夹中。进入一次 `examples`，就能用短文件名编译、运行和查看波形。

## 常用操作

在项目根目录的终端执行 `cd examples`。也可在 VS Code 中右键 `examples` → “在集成终端中打开”。之后以四位全加器为例：

```powershell
iverilog -g2012 -s tb_full_adder4 -o tb_full_adder4.vvp full_adder4.v tb_full_adder4.v
if ($LASTEXITCODE -eq 0) { vvp tb_full_adder4.vvp }
gtkwave tb_full_adder4.vcd
```

VVP 和 VCD 就在源文件旁边，无须切换输出目录；它们已被 Git 忽略。

## 案例索引

| 案例 | 设计文件 | 测试文件/顶层 | 复习重点与状态 |
|---|---|---|---|
| 计数器 | [counter.sv](counter.sv) | [counter_tb.sv](counter_tb.sv) / counter_tb | 时钟、复位、使能；25 项检查 |
| 四位全加器 | [full_adder4.v](full_adder4.v) | [tb_full_adder4.v](tb_full_adder4.v) / tb_full_adder4 | 模块例化、进位链；512 组检查 |
| 四选一选择器 | [mux4to1.v](mux4to1.v) | [tb_mux4to1.v](tb_mux4to1.v) / tb_mux4to1 | 组合 if；原 TB 的 rgb 调用未定义 |
| 双向 PAD | [pad.v](pad.v) | [tb_pad.v](tb_pad.v) / tb_pad | inout、z、多驱动；波形观察 |
| 过程循环 | [runoob.v](runoob.v) | runoob | 命名块、循环、层次访问；有同刻读写竞争 |
| 位序反转 | [endian_rvs.v](endian_rvs.v) | endian_rvs，无 TB | 函数、参数、位选取；仅展开不能证明功能正确 |

## 手动编译

下列命令均在 `examples` 中执行。编译成功后再执行对应的 `vvp`。

```powershell
# 计数器
iverilog -g2012 -s counter_tb -o counter_tb.vvp counter.sv counter_tb.sv
if ($LASTEXITCODE -eq 0) { vvp counter_tb.vvp }

# 四位全加器
iverilog -g2012 -s tb_full_adder4 -o tb_full_adder4.vvp full_adder4.v tb_full_adder4.v
if ($LASTEXITCODE -eq 0) { vvp tb_full_adder4.vvp }

# 双向 PAD
iverilog -g2012 -s tb_pad -o tb_pad.vvp pad.v tb_pad.v
if ($LASTEXITCODE -eq 0) { vvp tb_pad.vvp }

# 过程循环
iverilog -g2012 -s runoob -o runoob.vvp runoob.v
if ($LASTEXITCODE -eq 0) { vvp runoob.vvp }

# 位序反转：当前没有激励和功能自检查
iverilog -g2012 -s endian_rvs -o endian_rvs.vvp endian_rvs.v
```

不要直接编译所有 `*.v`：它们是独立练习，且选择器 TB 有已知错误。每次只列出要运行的设计和对应 TB。

## 可选的一键运行

`Ctrl+Shift+B` 仍运行计数器。“终端 → 运行任务 → Simulate: choose example (Icarus)”可选择其他案例。

脚本方式在项目根目录运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\simulate.ps1 -Example full-adder
```

在 `examples` 终端中，将脚本路径改为 `..\scripts\simulate.ps1`。脚本和手动操作都把结果放在 `examples`，编译结果名为顶层模块名加 `.vvp`。

## 新练习与笔记

直接在本文件夹新增 `主题.v` 和 `tb_主题.v`，文件名尽量与模块名一致。手动编译不需要登记脚本或新建子目录。波形名由 TB 的 `$dumpfile` 决定。

概念整理见 [Verilog 基础·学习地图](../verilog基础/00｜Verilog基础·学习地图.md)，实验经验见 [学习实验与易错点复盘](../verilog基础/14｜学习实验与易错点复盘.md)。笔记中的旧目录描述保留为学习历史，本页为当前文件位置与操作入口。
