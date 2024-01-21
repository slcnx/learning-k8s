# hub
加载基础设施相关的封装的包，[artifacthub.io](https://artifacthub.io/) , 
比较好的社区 官方、bitnami 

# 仓库
helm registry，里面有多个charts
oci直接使用目标helm chart

# helm registry 管理
```
helm repo add .... # 文档有
helm repo list  
helm repo update # 更新缓存
helm search repo <chartName> # 获取是否存在chart?
```

# 查看
```
# 清单
helm get manifests wordpress -n blog
# 用户定义的值
helm get values    wordpress -n blog
```

# 版本查看及回滚
```
helm history        wordpress -n blog
helm rollback 1     wordpress -n blog
```

# 手工写业务代码应用
```
helm
```
