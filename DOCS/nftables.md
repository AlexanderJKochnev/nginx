# firewall nftables
## НАСТРОЙКА И ЗАПУСК!!
### смотрим на каком порту ssh
grep -i "port" /etc/ssh/sshd_config

### настройка nftables (!!!внимание на п.3 - порт SSH!!!)
nano /etc/nftables.conf

#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority filter; policy drop;

                # 1. Разрешаем уже установленные соединения (чтобы не разорвался SSH)
                ct state established,related accept

                # 2. Разрешаем внутренний трафик сервера (loopback)
                iifname "lo" accept

                # 3. Разрешаем доступ по SSH (ЗАМЕНИТЬ на ваш реальный порт!)
                tcp dport 9229 accept

                # 4. Разрешаем порты Nginx (Веб-трафик)
                tcp dport { 80, 443 } accept

                # 5. Разрешаем порты почтового сервера
                tcp dport { 25, 465, 587, 993, 995 } accept
        }
        chain forward {
                type filter hook forward priority filter; policy drop;
                # А. Разрешаем контейнерам отвечать на входящие запросы
                # И получать ответы на их собственные запросы в интернет
                ct state established,related accept

                # Б. Разрешаем внутренний трафик виртуальных мостов Docker
                iifname "br-*" oifname "br-*" accept
                iifname "docker*" accept
                oifname "docker*" accept

                # В. РАЗРЕШЕНИЕ ДЛЯ ВАШЕЙ СЕТИ: Выпуск контейнеров наружу через enp9s0
                iifname "br-*" oifname "enp9s0" accept
                iifname "docker*" oifname "enp9s0" accept
        }
        chain output {
                type filter hook output priority filter; policy accept;
        }
}



### запуск службы nftables
systemctl enable nftables
systemctl start nftables

### проверка работы
systemctl status nftables
/usr/sbin/nft list ruleset








## Посмотреть список заблокированных IP в самом файрволе:
sudo nft list sets

## Посмотреть статус через Fail2ban
sudo fail2ban-client status nginx-noscript

## просмотр портов docker (не должно быть 0.0.0.0:80->80/tcp)

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
