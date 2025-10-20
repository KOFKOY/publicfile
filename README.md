### 一键部署服务
修改deployService.sh中的变量，选择部署 pgsql or springboot项目
在服务器执行 
```bash
chmod +x deployService.sh && sh deployService.sh
```

或者通过curl下载执行

```bash
curl -O https://ghproxy.cn/https://raw.githubusercontent.com/KOFKOY/publicfile/refs/heads/main/deployService.sh && \
chmod +x deployService.sh && \
sh deployService.sh && \
rm deployService.sh
```


代理地址
```txt
https://cdn.jsdelivr.net/gh/KOFKOY/publicfile@main/subs-check/mihomo.yaml
```
