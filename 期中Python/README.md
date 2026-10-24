# 期中：网络新闻热度预测

## 运行

在 Anaconda Prompt 中进入本文件夹，执行：

```powershell
conda env create -f environment.yml
conda activate news_popularity
python train.py
```

已创建环境时直接激活，不重复创建。首次运行会在缺少 CSV 时从 UCI 下载；交付包已附完整 CSV 和结果，可以离线训练。训练采用 CPU，适合本项目的两个树模型。

直接预测：

```powershell
Get-Content results/sample_input.json -Raw | python predict.py
```

需要完全一致的 Python 包版本时，创建 Python 3.11 环境后执行 `python -m pip install -r requirements-lock.txt`。本机已新建的环境名为 `news_popularity`，解释器位于 `D:\ProgramData\conda\envs\news_popularity\python.exe`。

## 文件

- `train.py`：读取、质量检查、EDA、预处理对比、三折网格搜索、最终评估与模型保存。
- `predict.py`：读取标准输入 JSON，输出预测 JSON，和期末网页共用。
- `data/`：完整 CSV、原始字段说明、来源及许可说明。
- `results/`：描述统计、数据检查、调参明细、两模型完整评价、划分索引、图表和逐图解读。
- `models/`：包含中位数填补、标准化、分类器的完整 Pipeline，以及输入字段顺序。
- `screenshots/`：环境配置与本次分析过程截图。

固定使用十项特征和 1400 次分享阈值。按 8∶2 分层随机划分；预处理在交叉验证折内拟合，测试集不参与调参。IQR 只对连续/计数特征识别长尾，不直接删除；是否周末不使用 IQR。两种模型分别比较仅填补与填补后标准化的三折 F1，交付统一的标准化版本，不以测试成绩挑选预处理。

数据来源及许可见 `data/数据来源与字段.md`。实际 CSV 为 39,644 行，与官网记录的 39,797 有差异，以读取结果为准。

本实验以课程演示为目的。没有新增深度学习模型，不直接处理文章正文；模型对当前中文新闻和未来传播效果的泛化尚未验证。
