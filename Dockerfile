FROM node:18.12.1-buster

RUN apt-get update

RUN apt-get install -y \
    unzip qpdf

CMD ["bash"]