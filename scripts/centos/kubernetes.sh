yum -y install pcp
systemctl enable pmcd && systemctl start pmcd
systemctl enable pmlogger && systemctl start pmlogger

rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0

yum install -y kubelet kubeadm kubectl kubernetes-cni


yum -y install etcd

mkdir ~/bin
curl -s -L -o ~/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o ~/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x ~/bin/{cfssl,cfssljson}
export PATH=$PATH:~/bin
mkdir ~/cfssl
cd ~/cfssl

# cfssl print-defaults config > ca-config.json
# cfssl print-defaults csr > ca-csr.json

echo '{ "signing": { "default": { "expiry": "43800h" }, "profiles": { "server": { "expiry": "43800h", "usages": [ "signing", "key encipherment", "server auth" ] }, "client": { "expiry": "43800h", "usages": [ "signing", "key encipherment", "client auth" ] }, "peer": { "expiry": "43800h", "usages": [ "signing", "key encipherment", "server auth", "client auth" ] } } } }' > ca-config.json

echo '{ "CN": "Vagrant CA", "key": { "algo": "rsa", "size": 2048 }, "names": [ { "C": "US", "L": "CA", "O": "Alpine Digital Research", "ST": "Boise", "OU": "The Nerdery" } ] }' > ca-csr.json

cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

echo '{ "CN": "172.20.254.2", "hosts": [ "172.20.254.2" ], "key": { "algo": "ecdsa", "size": 256 }, "names": [ { "C": "US", "L": "ID", "ST": "Boise" } ] }' > server.json

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server.json | cfssljson -bare server

mkdir /etc/ssl/certs/etcd
mv server*pem /etc/ssl/certs/etcd/
cp ca.pem /etc/ssl/certs/etcd

cfssl print-defaults csr > member1.json
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer member1.json | cfssljson -bare member1

cfssl print-defaults csr > client.json
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client

echo '
[member]
ETCD_NAME=kubernetes
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_SNAPSHOT_COUNT="10000"
ETCD_HEARTBEAT_INTERVAL="100"
ETCD_ELECTION_TIMEOUT="1000"
ETCD_LISTEN_PEER_URLS="http://localhost:2380"
ETCD_LISTEN_CLIENT_URLS="https://172.20.254.2:2379"
ETCD_MAX_SNAPSHOTS="5"
ETCD_MAX_WALS="5"

[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://localhost:2380"
ETCD_INITIAL_CLUSTER="kubernetes=https://localhost:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://172.20.254.2:2379"

[security]
ETCD_CERT_FILE="/etc/ssl/certs/etcd/server.pem"
ETCD_KEY_FILE="/etc/ssl/certs/etcd/server-key.pem"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_TRUSTED_CA_FILE="/etc/ssl/certs/etcd/ca.pem"
ETCD_PEER_CLIENT_CERT_AUTH="true"
ETCD_PEER_TRUSTED_CA_FILE="/etc/ssl/certs/etcd/ca.pem"

[logging]
ETCD_DEBUG="false"
# examples for -log-package-levels etcdserver=WARNING,security=DEBUG
#ETCD_LOG_PACKAGE_LEVELS=""
' > /etc/etcd/etcd.conf

chown -R etcd /etc/ssl/certs/etcd

