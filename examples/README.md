# Verilog 学习案例索引

设计与对应测试放在同一个案例目录，按编号复习。运行命令均在项目根目录 `D:\IV_ learning` 执行。

| 案例 | 文件 | 复习重点 | 当前验证情况 |
|---|---|---|---|
| [01 · 计数器](01-counter/) | counter.sv、counter_tb.sv | SV 时序过程、复位、使能、溢出、非阻塞赋值 | 有 25 项自检查 |
| [02 · 四位全加器](02-full-adder/) | full_adder4.v、tb_full_adder4.v | 组合表达式、模块例化、generate、进位链 | 有 512 组穷举自检查 |
| [03 · 四选一选择器](03-mux4to1/) | mux4to1.v、tb_mux4to1.v | if/else、组合赋值、wire/reg | TB 中未定义的 rgb 调用尚待修复 |
| [04 · 双向 PAD](04-pad/) | pad.v、tb_pad.v | inout、三态、多驱动、bufif1 | 波形观察型 TB，非自动自检查 |
| [05 · 过程循环](05-process-loop/) | runoob.v | 命名块、forever、层次访问、结束条件 | 仿真演示；同刻读写存在竞争，终止时刻不应视为固定 |
| [06 · 位序反转](06-endian-reverse/) | endian_rvs.v | function、参数、for、位选取 | 只有设计模块，无独立 TB；反转的是位序，不是多字节字节序 |

## 编译与运行

```powershell
# 默认运行计数器
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\simulate.ps1

# 选择案例：将 full-adder 换成表中其他名称
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\simulate.ps1 -Example full-adder
```

可选名称为 `counter`、`full-adder`、`mux4to1`、`pad`、`process-loop`、`endian-reverse`。

在 VS Code 中，`Ctrl+Shift+B` 仍运行计数器；通过“终端 → 运行任务 → Simulate: choose example (Icarus)”可选择其他案例。编译失败会停止，不运行旧的编译结果。

## 结果保存位置

所有运行结果集中到 `build/examples/对应案例目录/`：

```text
examples/02-full-adder/                 源代码
build/examples/02-full-adder/           编译结果与波形
  simulation.vvp
  tb_full_adder4.vcd
```

原来散落在项目根目录的 VVP/VCD 已按案例移到相应结果目录。原 `build/` 下计数器产物以 `legacy-` 前缀归档。旧结果仅作为历史文件保留，不能当作当前代码通过验证的证据；重新运行生成的 `simulation.vvp` 才对应本次编译。

如需手动运行，应先用绝对路径或从项目根目录编译，再切换到结果目录执行 `vvp`，使 `$dumpfile` 的相对文件名保存在该目录。

## 与学习笔记对照

- 概念目录：[Verilog 基础·学习地图](../verilog基础/00｜Verilog基础·学习地图.md)。
- 代码经验：[学习实验与易错点复盘](../verilog基础/14｜学习实验与易错点复盘.md)。
- 笔记整理于 2026-10-15，部分文件名和目录描述反映当时状态；本索引为 2026-10-16 整理后的实际路径。

## 新增案例约定

每个新主题新增 `examples/编号-主题/`，在其中放设计和 TB。优先保持文件名与模块名一致，测试模块使用 `tb_` 前缀（既有计数器沿用 counter_tb）。需要加入统一运行器时，在 `scripts/simulate.ps1` 的案例表与 ValidateSet、VS Code 选择列表中同时登记。
