FROM python:alpine

WORKDIR /app

#COPY requirements.txt requirements.txt
COPY . .
RUN pip install -r requirements.txt

#COPY . .
#CMD [ "python3", "pythonapp.py"]
ENTRYPOINT python pythonapp.py
