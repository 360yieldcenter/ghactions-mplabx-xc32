FROM ubuntu:20.04

RUN pwd

RUN ls

RUN dpkg --add-architecture i386 && apt-get update && \
  apt-get install -y libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 wget sudo make && \
  rm -rf /var/lib/apt/lists/*

RUN sudo apt-get update
RUN sudo apt-get -y install ruby -V 2.7.2
#RUN sudo gem install bundler -v 2.3.5
RUN sudo gem install ceedling -v 0.31.1
RUN sudo gem install dotenv -v 2.7.6

# Old code, from when unit testing was done with the simulator

# RUN wget -nv -O /tmp/xc32 http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v2.50-full-install-linux-installer.run && \
#  sudo chmod +x /tmp/xc32 &&  \
#  /tmp/xc32 --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32/v2.50 && \
#  rm /tmp/xc32
#RUN wget -nv -O /tmp/harmony http://ww1.microchip.com/downloads/en/DeviceDoc/harmony_v2_02_00b_linux_installer.run && \
#  sudo chmod +x /tmp/harmony && \
#  /tmp/harmony --mode unattended --unattendedmodeui none --installdir /opt/harmony/v2_02_00b
#RUN wget -nv -O /tmp/mplabx http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v5.45-linux-installer.tar &&\
#  cd /tmp && tar -xf /tmp/mplabx && rm /tmp/mplabx && \
#  mv MPLAB*-linux-installer.sh mplabx && \
#  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --8bitmcu 0 --16bitmcu 0 --othermcu 0 --collectInfo 0 --installdir /opt/mplabx && \
#  rm mplabx

COPY entry.sh /entry.sh

RUN chmod +x /entry.sh

ENTRYPOINT [ "/entry.sh" ]
