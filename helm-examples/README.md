# hub
加载基础设施相关的封装的包，[artifacthub.io](https://artifacthub.io/) , 
比较好的社区 官方、bitnami 

# 仓库
helm registry，里面有多个charts
oci直接使用目标helm chart

仓库被helm install之后，就变成运行的实例**helm release**

# helm registry 管理
```
helm repo add .... # 文档有
helm repo list  
helm repo update # 更新缓存
helm search repo <chartName> # 获取是否存在chart?
```

# release 查看
```
# 清单
helm get manifests wordpress -n blog
# 用户定义的值, 方便 helm install -f value.yaml wordpress
helm get values    wordpress -n blog
```

# release 版本更新及 回滚
```
# 更新
helm upgrade wordpress -n blog [options...]
# 回滚
helm history        wordpress -n blog # 查看历史版本
helm rollback 1     wordpress -n blog
```

# 删除应用
```
helm delete wordpress -n blog
```

# 手工写业务代码应用
```
helm
```
