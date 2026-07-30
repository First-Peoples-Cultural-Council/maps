FROM python:3.8-slim-bullseye

ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    libproj-dev \
    gdal-bin \
    libpq-dev \
    libpython3-dev \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /code
WORKDIR /code

COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

CMD ["./command.sh"]
