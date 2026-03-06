# 使用 Python 3.10
FROM python:3.10

# 设置工作目录
WORKDIR /app

# 复制依赖并安装
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制所有代码和数据 (包括 excel_data.db)
COPY . .

# Hugging Face 默认监听 7860 端口，且需要权限
RUN chmod -R 777 /app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]