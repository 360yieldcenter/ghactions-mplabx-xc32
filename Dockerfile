FROM ubuntu:20.04

ENV LANG C.UTF-8

# RUN pwd

# RUN ls

RUN dpkg --add-architecture i386 && apt-get update && \
  apt-get install -y libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 wget sudo make git && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/archives

RUN sudo apt-get update && \  
  sudo apt-get -y install ruby -V 2.7.2 && \
  sudo gem install ceedling -v 0.31.1 && \
  sudo gem install dotenv -v 2.7.6 && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/apt/archives

# Unit test is now performed with gcc & no simulator, but the build still requires the XC32 & Harmony. MPLab should not be required though.

RUN wget -nv -O /tmp/xc32 http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v3.01-full-install-linux-installer.run && \
  sudo chmod +x /tmp/xc32 &&  \
  /tmp/xc32 --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32/v3.01 && \
  rm /tmp/xc32

RUN wget -nv -O /tmp/xc32.tar https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc32-v4.35-full-install-linux-x64-installer.tar && \
  cd /tmp && tar -xf /tmp/xc32.tar && ls -la && mv xc32-v4.35-full-install-linux-x64-installer.run xc32 && \
  sudo chmod +x /tmp/xc32 &&  \
  /tmp/xc32 --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32/v4.35 && \
  rm /tmp/xc32 && rm /tmp/xc32.tar

# RUN wget -nv -O /tmp/harmony http://ww1.microchip.com/downloads/en/DeviceDoc/harmony_v2_02_00b_linux_installer.run && \
#   sudo chmod +x /tmp/harmony && \
#   /tmp/harmony --mode unattended --unattendedmodeui none --installdir /opt/microchip/harmony/v2_02_00b

RUN wget -nv -O /tmp/mplabx http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v6.00-linux-installer.tar &&\
  cd /tmp && tar -xf /tmp/mplabx && rm /tmp/mplabx && \
  mv MPLAB*-linux-installer.sh mplabx && \
  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --8bitmcu 0 --16bitmcu 0 --othermcu 0 --collectInfo 0 --installdir /opt/microchip/mplabx/v5.45 && \
  rm mplabx



RUN wget -nv -O /tmp/mk_dfp.1.10.146.atpack https://packs.download.microchip.com/Microchip.PIC32MK-MC_DFP.1.10.146.atpack && \
    mkdir -p ~/.mchp_packs/Microchip/PIC32MK-MC_DFP/1.10.146 && \
    unzip /tmp/mk_dfp.1.10.146.atpack -d ~/.mchp_packs/Microchip/PIC32MK-MC_DFP/1.10.146 && \
    rm -rf /tmp/mk_dfp.1.10.146.atpack

# DFP for HCB
RUN wget -nv -O /tmp/mk_dfp.1.11.151.atpack https://packs.download.microchip.com/Microchip.PIC32MK-MC_DFP.1.11.151.atpack && \
    mkdir -p ~/.mchp_packs/Microchip/PIC32MK-MC_DFP/1.11.151 && \
    unzip /tmp/mk_dfp.1.11.151.atpack -d ~/.mchp_packs/Microchip/PIC32MK-MC_DFP/1.11.151 && \
    rm -rf /tmp/mk_dfp.1.11.151.atpack

COPY entry.sh /entry.sh

RUN chmod +x /entry.sh

ENTRYPOINT [ "/entry.sh" ]
