注册 cloudflare 可以免费使用workers&pages,并提供免费二级域名

因为cf域名在国内被gfw，所以要使用别的方法访问


#### - 通过clouDNS免费获取二级域名，比如 test.ip-ddns.com
#### - 在CF中添加站点 test.ip-ddns.com，添加完成后会有两个 CF的NS名称服务器  比如  savanna.ns.cloudflare.com  trey.ns.cloudflare.com
#### - 在clouDNS中添加两条对应的NS记录,主机填写test.ip-ddns.com
#### - 填写完成后等待一段时间，观察CF中你添加的 test.ip-ddns.com 是否激活
#### - 激活完成后，查看边缘证书，找到通用的证书，查看证书验证 TXT 名称，比如 _acme-challenge.test.ip-ddns.com
#### - 在clouDNS中添加两条NS记录 主机填写_acme-challenge.test.ip-ddns.com 分别对应 savanna.ns.cloudflare.com  trey.ns.cloudflare.com
#### - 在需要映射的workers&pages中，添加自定义域名就可以了。比如  gh.test.ip-ddns.com
