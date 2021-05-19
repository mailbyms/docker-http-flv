# http-flv
HTTP-FLV服务器：nginx with nginx-http-flv-module  
拥有 `nginx-rtmp-module` 的所有功能，并增加 http-flv 

## 构建概况
- 基础镜像: `Centos7.9`
- `nginx`版本：1.8.1
- `nginx-http-flv-module`版本：1.2.7

集成 `ffmpeg-4.2.1`，在视频录制结束后，自动转码为 mp4 并生成一张截图

## 部署
镜像使用配置见 [docker-compose.yml](https://github.com/mailbyms/http-flv) 文件

## 资源访问
- 直播推流地址：rtmp://host:1935/live/{CHANNEL_ID}
- 直播列表：http://host:9090
- HTTP-FLV 地址：http://host:8002/liveflv?port=1935&app=live&stream={CHANNEL_ID}

## API 接口
- 开始录制：`POST` http://host:9090/control/record/start?rec=eduitv&app=live&name={CHANNEL_ID}
- 结束录制：`POST` http://host:9090/control/record/stop?rec=eduitv&app=live&name={CHANNEL_ID}

## HTTP-FLV 播放器 Demo
- 下载 flv.min.js  1.5 版本：https://www.bootcdn.cn/flv.js/
- 播放器 DEMO 代码见 player 目录，（另外替换成上面1.5版本的 flv.js）:https://github.com/saysmy/flvjs-pr354