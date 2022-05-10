# FROM node:12-alpine
# # FROM python:3.6.8-alpine
# # Adding build tools to make yarn install work on Apple silicon / arm64 machines
# RUN apk add --no-cache python2 g++ make
# WORKDIR /app
# COPY . .
# RUN yarn install --production
# # RUN pip install -r requirements.txt
# CMD ["node", "src/index.js"]
# # CMD ["python" , "app.py"]
# FROM nvidia/cuda:11.4.1-cudnn8-devel-ubuntu20.04

#ARG DEBIAN_FRONTEND=noninteractive
FROM alpine:latest
FROM nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04
ARG DEBIAN_FRONTEND=noninteractive
#RUN apk add --no-cache python3-dev \
 #   && pip3 install --upgrade pip
# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
    git \
    cmake \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3 \
    python3-pip \
    gcc \
    python3-tk \
    ffmpeg \
    libopenblas-dev \ 
    liblapack-dev

# Install dlib
RUN git clone https://github.com/davisking/dlib.git && \
    cd dlib && \
    mkdir build && \
    cd build && \
    cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 && \
    cmake --build . && \
    cd .. && \
    python3 setup.py install 

# Install Face Recognition and OpenCV
RUN pip3 install face_recognition opencv-python
# RUN python3 -m pip install -r requirements.txt
RUN pip freeze > requirements.txt

WORKDIR /app
COPY . .
CMD ["python" , "app.py"]

FROM alpine:latest
FROM nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04
ARG DEBIAN_FRONTEND=noninteractive
#RUN apk add --no-cache python3-dev \
 #   && pip3 install --upgrade pip
# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
    git \
    cmake \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3 \
    python3-pip \
    gcc \
    python3-tk \
    ffmpeg \
    libopenblas-dev \
    liblapack-dev

# Install dlib
RUN git clone https://github.com/davisking/dlib.git && \
    cd dlib && \
    mkdir build && \
    cd build && \
    cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 && \
    cmake --build . && \
    cd .. && \
    python3 setup.py install

# Install Face Recognition and OpenCV
RUN pip3 install face_recognition opencv-python
# RUN python3 -m pip install -r requirements.txt
RUN pip freeze > requirements.txt

WORKDIR /app
COPY . .

# EXPOSING THE PORT INSIDE DOCKER-IMAGE 
EXPOSE 5000

# MAKING THE CONTAINER EXECUTABLE
ENTRYPOINT ["python3"]
CMD ["python" , "app.py"]