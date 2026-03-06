# Railway 部署 — 一步一步教程（小白版）

下面按顺序做，做完一步再做下一步。遇到看不懂的可以慢慢来，不用急。

---

## 第一步：准备好 GitHub 账号和本项目的代码

### 1.1 如果你还没有 GitHub 账号

1. 打开浏览器，访问：**https://github.com**
2. 点击右上角 **Sign up**（注册）
3. 按页面提示填邮箱、密码、用户名，完成注册并验证邮箱

### 1.2 确保电脑上有这个项目

- 你的项目文件夹在：**`C:\Users\Administrator\Desktop\9.0网页计划`**
- 里面要有这些文件：`main.py`、`requirements.txt`、`Procfile`、`config.py` 等（和现在一样就行）

---

## 第二步：把项目上传到 GitHub（这样 Railway 才能拿到代码）

### 2.1 安装 Git（如果还没装）

1. 打开：**https://git-scm.com/download/win**
2. 下载 Windows 版，双击安装，一路点 **Next** 即可（默认选项就行）
3. 安装完成后，**关闭并重新打开** PowerShell 或「命令提示符」

### 2.2 在 GitHub 上新建一个「仓库」

1. 登录 **https://github.com**
2. 点击右上角 **+** → 选 **New repository**
3. **Repository name** 随便起一个英文名，例如：**lckde9**
4. 下面选 **Public**，**不要**勾选 "Add a README file"
5. 点 **Create repository**
6. 创建好后，页面上会有一个地址，类似：**https://github.com/你的用户名/lckde9.git**，先复制或记住

### 2.3 在电脑上把项目推送到这个仓库

**这些命令是干什么的（一句话版）：**

- `git init`：在当前文件夹里「建一个 Git 仓库」（让 Git 开始管理这个项目）
- `git add .`：把当前文件夹里**所有文件**都选上，准备上传
- `git commit -m "第一次提交"`：把选中的文件**打成一个包**，并写一句说明「第一次提交」
- `git branch -M main`：把当前分支名字改成 **main**（和 GitHub 默认一致）
- `git remote add origin https://github.com/...`：告诉 Git「我远程仓库的地址是这个」
- `git push -u origin main`：把刚才打的包**推送到 GitHub**，你的网页上就能看到文件了

**在哪里执行：** 打开 **PowerShell**（或「命令提示符」），**一行一行**复制粘贴执行即可。先执行第一句 `cd ...` 进入项目文件夹，再依次执行下面的。

**你的仓库是 lckde9、用户是 luosergio0-blip 时，直接复制下面整段执行：**

```powershell
cd "C:\Users\Administrator\Desktop\9.0网页计划"
git init
git add .
git commit -m "第一次提交"
git branch -M main
git remote add origin https://github.com/luosergio0-blip/lckde9.git
git push -u origin main
```

（如果你的仓库名或用户名不一样，把最后一行里的 `luosergio0-blip` 和 `lckde9` 改成你在 GitHub 上看到的。）

- 如果提示要登录 GitHub：按提示用浏览器登录或输入用户名 + 密码（或 Personal Access Token）
- 如果从没配置过 Git，可能先要执行（把邮箱和名字换成你的）：
  ```powershell
  git config --global user.email "你的邮箱@xxx.com"
  git config --global user.name "你的名字"
  ```
- **如果推送时提示 `excel_data.db` 太大**：可以先不推送数据库，只推送代码，网站会以「空库」先跑起来，后面再按文档用 `DB_DOWNLOAD_URL` 拉取数据

推送成功后，在 GitHub 网页上刷新，应该能看到项目里的文件了。

---

## 第三步：注册 Railway 并登录

1. 打开：**https://railway.app**
2. 点击 **Login**（登录）
3. 选 **Login with GitHub**，用你的 GitHub 账号授权
4. 授权完成后会进入 Railway 的「控制台」页面

---

## 第四步：在 Railway 里「新建项目」并选你的 GitHub 仓库

1. 在 Railway 页面点击 **New Project**（新建项目）
2. 在弹出来的选项里选 **Deploy from GitHub repo**（从 GitHub 仓库部署）
3. 如果是第一次用，会提示要安装 **Railway 的 GitHub 应用**：
   - 点 **Configure GitHub App** 或类似按钮
   - 在 GitHub 里选 **Only select repositories**，勾选你刚创建的那个仓库（如 lckde9）
   - 点 **Save** 或 **Install**
4. 回到 Railway，在仓库列表里找到你的 **lckde9**（或你起的名字），点一下选中它
5. Railway 会开始「构建」你的项目，等一两分钟，下面会出现部署状态（Building… / Success）

---

## 第五步：给项目加一个「持久化磁盘」（Volume）

这样以后数据库和图片不会因为重新部署而丢失。

1. 在 Railway 里，点击你刚部署出来的那个**服务**（一个方框，上面有你的仓库名）
2. 在上面或侧边找到 **Variables**（变量）或 **Settings**（设置）
3. 在 **Settings** 里往下找，有一个叫 **Volumes** 的区域
4. 点 **Add Volume** 或 **+ New Volume**
5. **Mount Path**（挂载路径）里填：**`/data`**（就这四个字符，不要多也不要少）
6. 点 **Add** 或 **Confirm** 保存

---

## 第六步：设置环境变量，告诉网站「数据放在 /data」

1. 还是在当前这个服务里，点 **Variables**（变量）
2. 点 **+ New Variable** 或 **Add Variable**
3. **变量名**填：**`DATA_DIR`**
4. **值**填：**`/data`**
5. 保存（有的界面是自动保存的）

这样网站就会把数据库和图片写到 `/data`，也就是你刚挂载的磁盘上，重启也不会丢。

---

## 第七步：打开「公开链接」，访问你的网站

1. 在同一个服务的 **Settings** 里，找到 **Networking** 或 **Public Networking**
2. 点 **Generate domain** 或 **Add public URL**（生成域名 / 添加公开地址）
3. Railway 会给你一个地址，类似：**https://xxx-production-xxxx.up.railway.app**
4. 复制这个地址，在浏览器里打开

如果一切正常，你会看到 Excel 查询站的页面。  
一开始可能是「空库」（没有数据、没有工作表），这是正常的；你可以先确认页面能打开，再考虑往库里放数据（见下面「想要带数据上线」）。

---

## 小结：你做到了哪些

- 第一步～第二步：代码在 GitHub 上  
- 第三步～第四步：Railway 从 GitHub 拉代码并自动部署  
- 第五步～第六步：加了持久化磁盘和 `DATA_DIR`，数据会保存在 Railway 上  
- 第七步：用公开链接访问网站  

---

## 想要「带数据」上线怎么办？

你现在网站能打开，但还没有 Excel 导入的数据。可以选下面一种方式：

### 方式 A：先在小数据上试一次（推荐先试这个）

1. 在你**自己的电脑**上，在项目文件夹里打开 PowerShell，执行：
   ```powershell
   cd "C:\Users\Administrator\Desktop\9.0网页计划"
   $env:IMPORT_MAX_ROWS = "3000"
   python import_excel.py
   ```
   会生成一个较小的 `excel_data.db`（只含前 3000 行）。
2. 把 `excel_data.db` 上传到能生成「直链」的地方，例如：
   - **GitHub Release**：在仓库里点 **Releases** → **Create a new release**，上传 `excel_data.db`，发布后点文件可以复制下载链接
   - 或任何能直接下载的网盘/对象存储链接
3. 在 Railway 的 **Variables** 里再加一个变量：
   - 变量名：**`DB_DOWNLOAD_URL`**
   - 值：你刚才得到的 **完整下载链接**（浏览器打开这个链接会直接下载文件）
4. 在 Railway 里点一次 **Redeploy**（重新部署），等部署完成后再打开你的网站链接，就会有数据了。

### 方式 B：用完整数据库（文件会比较大）

- 和方式 A 一样，只是不设 `IMPORT_MAX_ROWS`，直接运行 `python import_excel.py` 生成完整的 `excel_data.db`，再上传并把下载链接填到 **DB_DOWNLOAD_URL**，然后重新部署。

---

## 常见问题

**Q：推送代码时提示「文件太大」？**  
A：可以先在项目里执行 `git rm --cached excel_data.db`（如果之前加过），并在 `.gitignore` 里确保有 `excel_data.db`，然后只推送代码；数据用上面的 **DB_DOWNLOAD_URL** 方式在 Railway 里拉取。

**Q：打开链接显示「无法访问」或 502？**  
A：等 1～2 分钟再试；或到 Railway 的 **Deployments** 里看最新一次部署是否成功（绿色勾），若有红色叉可以点进去看报错信息。

**Q：页面打开了但是「暂无工作表」？**  
A：说明数据库是空的，按上面「想要带数据上线」设置 **DB_DOWNLOAD_URL** 并重新部署即可。

**Q：找不到 Variables / Volumes 在哪？**  
A：一定要先点进「当前这个服务」（显示你仓库名的那个卡片），再在顶部的 **Variables**、**Settings** 里找；不同界面版本可能名字略有不同，找 **Variables** 和 **Volumes** 即可。

---

按顺序做完这七步，你的 Excel 查询站就会在 Railway 上跑起来了。遇到哪一步卡住，可以把提示信息或截图发出来，再继续往下排查。
