FROM python:slim-bullseye

ENV PYTHONUNBUFFERED=1
USER root
WORKDIR /app


RUN  /usr/local/bin/python -m pip install --upgrade pip

# Add PostgreSQL repository and install PostgreSQL
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    apt-get clean \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-bullseye.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-bullseye.gpg] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y postgresql-15 postgresql-client-15

# RUN pip3 install Pillow
# RUN pip3 install psycopg2-binary
RUN pip3 install psycopg2-binary
RUN pip3 install greenlet cffi


RUN pip3 install --upgrade pip && \
    pip3 cache purge && \
    apt-get install -y zlib1g-dev


# COPY requirements.txt requirements.txt
COPY requirements.txt /app/requirements.txt

# Install All the Neccesary Packages From requirements.txt
RUN pip3 install -r requirements.txt --verbose --no-cache-dir

# Upgrading pip
COPY . /app

# Expose the PostgreSQL port
EXPOSE 5432

# Start PostgreSQL service
CMD ["pg_ctlcluster", "15", "main", "start", "-w"]
# ____________

EXPOSE 8000 9000 7000
