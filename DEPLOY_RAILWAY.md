# 在 Railway 上部署本项目的步骤

> **如果你是第一次部署、希望有人一步一步带着做**，请直接看 **[Railway部署一步一步.md](Railway部署一步一步.md)**（从注册 GitHub、推送代码到生成访问链接都有写）。

本文说明如何把本项目部署到 [Railway](https://railway.app)，并利用 **Volume 持久化** 数据库与图片（重启/重新部署后数据不丢失）。

---

## 一、部署前准备

### 1. 代码放到 Git 仓库

- 确保项目已推送到 **GitHub**（或 Railway 支持的其他 Git 托管）。
- Railway 通过连接 GitHub 仓库进行自动构建与部署。

### 2. 数据如何带上线（二选一）

- **方式 A：先空库上线，再用 DB_DOWNLOAD_URL 拉取**  
  - 本地执行 **`python import_excel.py`** 生成 `excel_data.db`（和 `static/images/`）。  
  - 将 `excel_data.db` 上传到可公网访问的地址（如 GitHub Release、对象存储），得到直链 URL。  
  - 在 Railway 里设置环境变量 **`DB_DOWNLOAD_URL`** = 该 URL。  
  - 应用首次启动时若发现 `/data/excel_data.db` 不存在，会自动下载到 Volume，实现“带数据”上线。  
  - 若数据库里引用了图片，需要保证部署环境中能访问到这些图片（见下方「图片说明」）。

- **方式 B：小库随仓库一起推送（无需 Volume 也可跑）**  
  - 本地执行 **`IMPORT_MAX_ROWS=3000 python import_excel.py`**，得到体积较小的 `excel_data.db`。  
  - 将 `excel_data.db` 和 `static/images/` 一并提交并推送到 Git（可不设 `DATA_DIR`，不用 Volume）。  
  - 注意：Railway 默认每次部署会清空非 Volume 目录，**若不挂 Volume 且不设 DATA_DIR**，重启后数据会丢；若希望持久化，请用方式 A + Volume。

---

## 二、在 Railway 创建项目并部署

1. **注册/登录**  
   打开 [https://railway.app](https://railway.app)，用 GitHub 登录。

2. **新建项目并连接仓库**  
   - 点击 **New Project**。  
   - 选 **Deploy from GitHub repo**，授权后选择**本项目的仓库**。  
   - 选中仓库后，Railway 会按仓库内的 **Procfile** 或 Nixpacks 自动识别为 Python 项目并构建。

3. **挂载持久化 Volume（推荐）**  
   - 在项目里选中刚创建的服务（Service），进入 **Variables** 或 **Settings**。  
   - 找到 **Volumes**，点击 **Add Volume**。  
   - 挂载路径填：**`/data`**（必须一致，应用用此路径存数据库和图片）。  
   - 保存。

4. **设置环境变量**  
   在服务的 **Variables** 中新增：

   | 变量名 | 值 | 说明 |
   |--------|-----|------|
   | **`DATA_DIR`** | **`/data`** | 与 Volume 挂载路径一致，数据库和图片会写在这里 |
   | **`DB_DOWNLOAD_URL`** | （可选）你的 `excel_data.db` 直链 | 首次启动时若 `/data/excel_data.db` 不存在会从此下载 |
   | **`EXCEL_PATH`** | （可选） | 仅当在 Railway 上跑导入时才需要（一般不在此跑大文件导入） |

   **注意**：`PORT` 由 Railway 自动注入，无需手动设置；启动命令已写在 Procfile 中（`uvicorn ... --port $PORT`）。

5. **部署与访问**  
   - 推送代码到 GitHub 后，Railway 会自动重新构建并部署。  
   - 部署完成后在 **Settings** 里可看到 **Public URL**（如 `https://xxx.up.railway.app`），用该链接访问站点即可。

---

## 三、启动命令说明

项目根目录已提供 **Procfile**：

```text
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

Railway 会使用该命令启动 Web 服务；无需在控制台再填 Start Command（除非你想覆盖）。

---

## 四、图片说明

- 使用 **DATA_DIR=/data** 时，图片目录为 **/data/images**，应用会从该目录提供 `/static/images/` 下的资源。  
- 若通过 **DB_DOWNLOAD_URL** 拉取的是在本地导入生成的库，库中图片路径多为 `static/images/...`，文件名与本地 `static/images/` 一致。若要在 Railway 上正常显示图片，需保证这些文件出现在 **/data/images/** 下，例如：  
  - 将本地 `static/images/` 打包上传到某处，再在服务器或一次性脚本中下载并解压到 `/data/images/`；或  
  - 在 Railway 上执行一次导入（需能访问到 Excel 或数据源），由 `import_excel.py` 写入 `/data/images/`。  
- 若暂时不需要图片展示，只设 **DB_DOWNLOAD_URL** 即可，搜索与表格功能可正常使用。

---

## 五、简要检查清单

- [ ] GitHub 仓库已连接，Railway 能自动构建。  
- [ ] 已添加 Volume，挂载路径为 **`/data`**。  
- [ ] 已设置环境变量 **`DATA_DIR=/data`**。  
- [ ] （可选）已设置 **`DB_DOWNLOAD_URL`**，且首次启动后可在 `/data` 中看到 `excel_data.db`。  
- [ ] 使用 Public URL 能打开首页并正常搜索、查看详情。

按上述步骤即可在 Railway 上搭建并持久化运行本 Excel 查询站。
