FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04
RUN set -ex && \
    apt update && \
    apt install -y wget git python3 python3-venv python3-pip xdg-utils libgoogle-perftools-dev && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
RUN ln -s /usr/local/cuda/lib64/libcudart.so.11.0 /usr/local/cuda/lib64/libcudart.so

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

RUN pip install --no-cache-dir torch==1.13.1+cu117 torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117

RUN set -ex && cd stable-diffusion-webui \
    && mkdir repositories \
    && git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion \
    && git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers\
    && git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer \
    && git clone https://github.com/salesforce/BLIP.git repositories/BLIP \
    && git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion \
    && git clone https://github.com/Stability-AI/stablediffusion repositories/stable-diffusion-stability-ai \
    && pip install --no-cache-dir transformers diffusers invisible-watermark --prefer-binary \
    && pip install --no-cache-dir git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary \
    && pip install --no-cache-dir git+https://github.com/TencentARC/GFPGAN.git --prefer-binary \
    && pip install --no-cache-dir git+https://github.com/mlfoundations/open_clip.git --prefer-binary \
    && pip install --no-cache-dir -r repositories/CodeFormer/requirements.txt --prefer-binary \
    && pip install --no-cache-dir -r requirements.txt --prefer-binary 

RUN pip install --no-cache-dir opencv-contrib-python-headless opencv-python-headless python-socketio pycloudflared discord-webhook segment-anything scikit-learn segmentation-refinement
RUN pip install --no-cache-dir xformers==0.0.16
RUN pip install --no-cache-dir --upgrade fastapi==0.90.1

WORKDIR /stable-diffusion-webui
RUN sed -i -e 's/    start()/    #start()/g' launch.py
RUN python3 launch.py --skip-torch-cuda-test
EXPOSE 7860

CMD ["python3", "webui.py", "--listen", "--xformers",  "--medvram", "--hide-ui-dir-config", "--max-batch-count=100","--enable-insecure-extension-access"]
