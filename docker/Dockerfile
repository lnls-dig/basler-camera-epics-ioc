FROM debian:11.6

ARG JOBS=1

ENV TZ America/Sao_Paulo
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /opt

RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        git \
        wget \
        ca-certificates

ENV EPICS_BASE_VERSION 7-0-7

COPY --chmod=777 docker/install_epics.sh .
RUN ./install_epics.sh

ENV ASYN_VERSION 4-43
ENV CALC_VERSION 3-7-4
ENV SSCAN_VERSION 2-11-5
ENV BUSY_VERSION 1-7-3
ENV AUTOSAVE_VERSION 5-10-2

COPY --chmod=777 docker/install_modules.sh .
RUN ./install_modules.sh

ENV AREA_DETECTOR_VERSION 3-12-1

COPY --chmod=777 docker/install*.sh .
RUN ./install_adaravis.sh && \
    rm install*.sh

WORKDIR /opt/basler-camera-epics-ioc

COPY . .

RUN make -j ${JOBS} && \
    chmod +x iocBoot/iocBaslerCamera/st.cmd

RUN apt remove -y \
        git \
        wget \
        build-essential && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/basler-camera-epics-ioc/iocBoot/iocBaslerCamera

CMD ["bash", "-c", "./st.cmd"]
