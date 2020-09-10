# Docker Swarm
## Swarm 
- Swarmı aktif ediyor.
    - `docker swarm init`
- Swarm'a bağlı diğer makineleri görmek için
    - `docker node ls`
- Swarmdaki diğer makinelerin rollerini güncellemek için
    - `docker node update --role manager node2`
- Swarmdaki roller
    - `Manager`: yetkili worker (galiba)
    - `Leader`: swarm'in en yetkili herkesin bağlandığı node
    - `Worker`: yetkisiz katılımcı swarm kodlarını çalıştıramaz
## Servisler
- Swarmda servis oluşturma 
    - `docker service create --replicas 3 alpine ping 8.8.8.8`
- Swarmda service listeleme, hangi serviceler var
    - `docker service ls`
- Swarmda service ile alakalı detaylı bilgi
    - `docker service ps ${NAME}`
- Docker service 

## Overlay Networkü
- Muhtemelen sadece Swarm ile çalışıyor. Bir service oluşturduğumuzu düşünelim, bu serviceten sadece 1 tane replica olsun. Bu swarm'da 3 tane node olduğunu düşünelim. Bu service 5000'portundan hizmet verecek şekilde ayarladık. Bundan sonra hangi node'un 5000 portuna istek atarsanız atın sizi nginx karşılayacaktır. Overlay networkü bu şekilde çalışıyor.
- `docker network create --driver overlay my_overlay_network`
- `docker service create --port 5000:80 --network my_overlay_network nginx:alpine`

## Docker secret
- Service oluşturuken --secret parametresi ile oluşturduğunuz secret'i veriyorsunuz. Dokcer sizin yerinize bu secret'ın dosyasını volume olarak bind ediyor. (secret dosyasını hostta silerseniz veya değiştirirseniz ne olur bilmiyorum). Path olarak `/run/secrets/${SECRET_NAME}`'e atıyor.