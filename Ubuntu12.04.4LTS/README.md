Ubuntu12.04.4LTS
=======
Ubuntu12.04.4LTSの構築スクリプト

## 初期構築
```
apt-get update
apt-get upgrade

apt-get install -y git
git clone https://github.com/ftakao2007/build.git
echo "set encoding=utf-8 >> ~/.vimrc"
cd build/Ubuntu12.04.4LTS/
./001_init.sh [git_user] [git_email] [server_user]
```

## スクリプト
### 001_init.sh
初期設定用スクリプト。  
第一引数:gitユーザ名  
第二引数:gitメールアドレス  
第三引数:サーバの個人ユーザ  
以下のスクリプトを実行する。

### 002_git.sh
gitの設定スクリプト。最後にgithubに貼り付ける公開鍵を出力する。

### 009_dtivps_init.sh
DTIのVPS用設定。
- ipv6停止
- sudo実行時のワーニング回避
- perl実行時のワーニング回避
- Ajaxterm停止

### 011_useradd.sh
sudo権限を持つ個人ユーザ作成
