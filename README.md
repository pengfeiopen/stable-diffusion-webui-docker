# stable-diffusion-webui-docker

运行前提条件

 1.已安装docker

 2.已安装nvidia-container-runtime

 3.在docker配置文件daemon.json添加 "default-runtime": "nvidia"
 

运行
```
docker run -id   -v /home/models:/stable-diffusion-webui/models/Stable-diffusion  -v /home/sd-v1/extensions:/stable-diffusion-webui/extensions -v /home/sd-v1/ouputs:/stable-diffusion-webui/outputs -v /home/cache:/root/.cache -v /home/sd-v1/ui/config.json:/stable-diffusion-webui/config.json  -v /home/sd-v1/ui/ui-config.json:/stable-diffusion-webui/ui-config.json -p 7860:7860 --name sd-webui xxxx/public/stable-diffusion-webui:v1-gke-6
```

备注：ui-config.json ui-config.json 挂载出来是为了方便修改

现在可以访问你的stable-diffusion-webui

```
http://10.0.0.10:7860
```

![image](https://user-images.githubusercontent.com/97205802/233243289-0647c141-7e5a-4e39-bd0b-6ddac5157311.png)

