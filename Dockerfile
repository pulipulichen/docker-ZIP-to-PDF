FROM node:18.12.1-buster

RUN apt-get update

RUN apt-get install -y \
    unzip img2pdf qpdf

CMD ["bash"]