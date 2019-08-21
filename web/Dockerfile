FROM python:3.6

ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

COPY requirements.txt /code/
RUN pip install -r requirements.txt

RUN apt-get update \
  && apt-get install -y libproj-dev gdal-bin libpq-dev libpython3-dev \
  default-libmysqlclient-dev build-essential

CMD ./command.sh
