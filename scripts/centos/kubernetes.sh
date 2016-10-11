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

# setenforce 0

yum install -y kubelet kubeadm kubectl kubernetes-cni

# systemctl enable kubelet && systemctl start kubelet

# kubeadm init

# sed -i 's/443/6443/' /etc/kubernetes/admin.conf
# sed -i 's/443/6443/' /etc/kubernetes/kubelet.conf
# sed -i 's/443/6443/' /etc/kubernetes/manifests/kube-apiserver.conf

# systemctl restart kubelet

# kubectl taint nodes --all dedicated-
# kubectl apply -f https://git.io/weave-kube