FROM python:3.11-slim

WORKDIR /app

# Dependências para psycopg2 e utilitários
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Pacotes Python (ETL)
RUN pip install --no-cache-dir \
    pandas \
    sqlalchemy \
    psycopg2-binary \
    python-dotenv

# Copia tudo do projeto (opcional, mas útil)
COPY . .

CMD ["bash"]
