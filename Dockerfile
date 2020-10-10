FROM ubuntu as builder

RUN DEBIAN_FRONTEND='noninteractive' apt-get update
RUN DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install apt-utils git ca-certificates wget unzip
RUN mkdir -p /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_2/models && \
    cd /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_2/models && \
    wget --progress=bar:force:noscroll  https://hcicloud.iwr.uni-heidelberg.de/index.php/s/XXVKT5grAquXNqi/download 
RUN cd /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_2/ && \
    unzip -x models/download && \
    cd models &&\
    for f in *.tar.gz; do tar xvf "$f"; done
RUN pwd
RUN mkdir -p /root/.config/GIMP/2.10/plug-ins && \
    mkdir -p /root/.config/GIMP/2.10/gradients && \
    git clone https://github.com/BorisAbramovich/GIMP-style-transfer.git && \
    mv  GIMP-style-transfer/.git  /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer && \
    cd /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer && \
    git reset --hard HEAD && \
    mkdir /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer3 &&\
    mv /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/GIMP-style-transfer3.py /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer3
#    git clone https://github.com/Davide-sd/GIMP-style-transfer.git
RUN DEBIAN_FRONTEND='noninteractive' apt-get update
RUN DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install gimp
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
RUN echo Asia/Jerusalem > /etc/timezone
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install python
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install curl
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
RUN python2 get-pip.py
#RUN pip install tensorflow-cpu==2.1.0  pillow==3.4.2 scipy numpy tf_slim tensorlayer==2.0.0 --use-feature=2020-resolver
#RUN pip install  tensorflow-cpu tensorlayer scikit-learn tf_slim --use-feature=2020-resolver
RUN pip install  tensorflow-cpu scikit-learn tf_slim pillow --use-feature=2020-resolver
#RUN pip install tensorflow-cpu==2.1.0  pillow==3.4.2 scipy numpy tf_slim tensorlayer --use-feature=2020-resolver
#RUN pip install tensorflow-cpu==1.15.0 pillow moviepy==1.0.2 tf-slim tensorlayer --use-feature=2020-resolver
#RUN pip install tensorflow==1.12.3  tensorlayer==1.11.1 moviepy==1.0.2 --use-feature=2020-resolver
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install python-cairo python-gobject-2
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-6_amd64.deb
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gimp/gimp-python_2.10.8-2_amd64.deb
RUN dpkg -i python-gtk2_2.24.0-6_amd64.deb
RUN dpkg -i gimp-python_2.10.8-2_amd64.deb
RUN git clone https://github.com/lengstrom/fast-style-transfer.git &&\
    cp fast-style-transfer/src/transform.py /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/src
RUN chmod +x ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/GIMP-style-transfer.py
RUN mkdir /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSyZ0RyTGU0Q2xiU28' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/the-scream.ckpt
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSyQU1sYW02Sm9kV3c' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/la-muse.ckpt
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSyb0NuYmk2ZEpOR0E' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/udnie.ckpt
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSyVGk0TC10bDF1S28' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/great-wave.ckpt
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSyaEJlSFlIeUxweGs' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/rain-princess.ckpt
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B9jhaT37ydSySjNrM3J5N2gweVk' -O ~/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_1/models/the-shipwreck.ckpt
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install gimp-gmic gimp-dcraw gimp-help-en gimp-lensfun gimp-plugin-registry
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install build-essential pkg-config libgimp2.0-dev liblqr-1-0-dev intltool
RUN git clone https://github.com/carlobaldassi/gimp-lqr-plugin.git && \
    cd gimp-lqr-plugin/ && \
    ./configure && \
    make && \
    make install
COPY ["eaw",  "mm extern eaw.py", "/root/.config/GIMP/2.10/plug-ins/"]
RUN apt-get install -y --no-install-recommends virtualenv 
RUN cd /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/ && \
    virtualenv -p2.7 implementation_3_env && \ 
    . implementation_3_env/bin/activate && \
    pip install tensorflow==1.12.0 tensorlayer==1.11.1 && \
    sed -i '1644 s/))/), allow_pickle=True)/' /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_3_env/lib/python2.7/site-packages/tensorlayer/files/utils.py
RUN git clone https://github.com/tensorlayer/pretrained-models.git && \
    mkdir /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_3/models && \
    cp pretrained-models/models/style_transfer_models_and_examples/pretrained_vgg19_* /root/.config/GIMP/2.10/plug-ins/GIMP-style-transfer/implementation_3/models
RUN cd /root/.config/GIMP/2.10/plug-ins/ && \
    git clone https://github.com/kritiksoman/GIMP-ML.git && \
    cd GIMP-ML/gimp-plugins && \
    virtualenv -p2.7 gimpenv && \
    . gimpenv/bin/activate && \ 
    pip install torchvision "opencv-python<=4.3" numpy future torch scipy typing enum pretrainedmodels requests && \
    wget https://github.com/tanaikech/goodls/releases/download/v1.2.7/goodls_linux_amd64 && \
    chmod +x ./goodls_linux_amd64 && \
    echo "https://drive.google.com/drive/folders/10IiBO4fuMiGQ-spBStnObbk9R-pGp6u8" | ./goodls_linux_amd64 -key AIzaSyCQXE69OVk-sijCK1sNJXVpy3t1XnCtdag && \
    rm ./goodls_linux_amd64 

FROM ubuntu
RUN DEBIAN_FRONTEND='noninteractive' apt-get  update
RUN DEBIAN_FRONTEND='noninteractive' apt-get  upgrade -y
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install apt-utils wget
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install gimp
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
RUN echo Asia/Jerusalem > /etc/timezone
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install python
COPY --from=builder get-pip.py .
RUN python2 get-pip.py
RUN pip install  tensorflow-cpu scikit-learn tf_slim pillow --use-feature=2020-resolver
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install python-cairo python-gobject-2
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-6_amd64.deb
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gimp/gimp-python_2.10.8-2_amd64.deb
RUN dpkg -i python-gtk2_2.24.0-6_amd64.deb
RUN dpkg -i gimp-python_2.10.8-2_amd64.deb
RUN DEBIAN_FRONTEND='noninteractive' apt-get -y --no-install-recommends install gimp-gmic gimp-dcraw gimp-help-en gimp-lensfun gimp-plugin-registry python-tk
RUN mkdir -p /root/.config/GIMP/2.10/
COPY --from=builder /root/.config/GIMP/2.10/plug-ins/ /root/.config/GIMP/2.10/plug-ins
COPY --from=builder /usr/share/gimp-lqr-plugin/ /usr/share/gimp-lqr-plugin/
COPY --from=builder /usr/share/gimp/2.0/scripts/batch-gimp-lqr.scm /usr/share/gimp/2.0/scripts
COPY --from=builder /usr/lib/gimp/2.0/plug-ins/gimp-lqr-plugin  /usr/lib/gimp/2.0/plug-ins
COPY --from=builder /usr/lib/gimp/2.0/plug-ins/plug_in_lqr_iter /usr/lib/gimp/2.0/plug-ins
RUN mkdir /root/.config/GIMP/2.10/gradients
RUN echo '(plug-in-path \"${gimp_dir}/plug-ins:${gimp_dir}/plug-ins/GIMP-ML/gimp-plugins:${gimp_plug_in_dir}/plug-ins\")' >> /root/.config/GIMP/2.10/gimprc
#CMD ["/usr/bin/gimp"]
