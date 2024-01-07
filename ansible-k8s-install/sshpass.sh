[ -f ~/.ssh/id_rsa.pub  ] || ssh-keygen -t rsa -b 2048 -P ''
apt install sshpass -y
REMOTE_PORT="22"
REMOTE_USER="root"
REMOTE_PASS="mageedu"
hosts=(
10.10.52.38
10.10.53.24
10.10.54.110
10.10.57.7
)

for REMOTE_HOST in ${hosts[@]};do
 REMOTE_CMD="echo ${REMOTE_HOST} is successfully!"
 ssh-keyscan -p "${REMOTE_PORT}" "${REMOTE_HOST}" >> ~/.ssh/known_hosts
 sshpass -p "${REMOTE_PASS}" ssh-copy-id "${REMOTE_USER}@${REMOTE_HOST}"
 echo ${REMOTE_HOST} 免秘钥配置完成!
done

