FROM python:3.11-slim

WORKDIR /app

# Dependências do sistema (psycopg2 + utilitários)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    curl \
    git \
 && rm -rf /var/lib/apt/lists/*

# Pacotes Python (ETL)
RUN pip install --no-cache-dir \
    pandas \
    sqlalchemy \
    psycopg2-binary \
    python-dotenv \
    openpyxl

# Copia o projeto
COPY . .

CMD ["bash"]
