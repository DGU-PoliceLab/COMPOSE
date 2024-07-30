# Step 1. 도커 이미지 설치 
도커 이미지 설치를 위해 **setup.bat** 파일을 실행합니다.

만약 setup.bat 파일 실행 중 오류가 발생한다면 아래 과정을 따릅니다.

*./images 폴더에서*
```
docker load -i pls-web.tar
docker load -i pls-was.tar
docker load -i pls-mysql.tar
docker load -i pls-redis.tar
```

위 과정을 완료한 후, **docker images** 명령어를 통해 이미지 설치를 확인합니다.
```
C:\>docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
web          latest    b74150de491d   46 minutes ago   59.7MB
was          latest    7cc2b9cf4205   56 minutes ago   1.63GB
mysql        latest    7ce93a845a8a   5 days ago       586MB
redis        latest    6c00f344e3ef   2 months ago     116MB
```

# Step 2. 도커 컨테이너 실행
> Step 1에서 setup.bat 실행 시, 문제없이 완료되었다면 이 단계를 건너 뛸 수 있습니다.

도커 컨테이너 실행을 위해 **docker-compose.yml** 파일이 있는 폴더에서 아래 명령어를 실행합니다.
```
docker-compose -f docker-compose.yml up -d
```
위 과정을 완료한 후, **docker ps** 명령어를 통해 컨테이너 실행을 확인합니다.
```
C:\>docker ps
CONTAINER ID   IMAGE     COMMAND                   CREATED          STATUS          PORTS                                      NAMES
7a4c9a04d5d7   redis     "docker-entrypoint.s…"   30 minutes ago   Up 30 minutes   0.0.0.0:16379->6379/tcp                    pls-redis
ead6a63a0660   web       "/docker-entrypoint.…"   30 minutes ago   Up 30 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   pls-web
3219599e364e   was       "hypercorn run:app -…"   30 minutes ago   Up 30 minutes   0.0.0.0:40000->40000/tcp                   pls-was
43852f418e28   mysql     "docker-entrypoint.s…"   30 minutes ago   Up 30 minutes   33060/tcp, 0.0.0.0:13306->3306/tcp         pls-mysql
```

# Step3. MySQL 데이터베이스 설정
> Step 1에서 setup.bat 실행 시, 문제없이 완료되었다면 이 단계를 건너 뛸 수 있습니다.

MySQL Workbench를 통해 이 작업을 진행합니다. 
[MySQL Workbench Download](https://dev.mysql.com/downloads/workbench/)

MySQL Workbench에 접속해 연결을 추가합니다.

- Connection Name: pls
- Hostname: 127.0.0.1 or localhost
- Port: 13306
- Username: root

정보 기입 후, 우측 하단 OK 버튼을 눌러 연결을 추가합니다.

위 과정에서 만들었던 pls 연결을 눌러 접속합니다.
- Password: 1q2w3e4r!

좌측 메뉴의 Administration탭에서 Data Import 메뉴를 선택합니다.

아래와 같이 설정 후, 우측 하단 Start Import 버튼을 클릭합니다.
- Import Options > Import from Self-Contained File: **pls-mysql.sql 경로**
- Default Schema to be Imported To > Default Target Schema: **pls**

위 과정을 완료한 후, pls 스키마에 cctv, event, location, log 테이블 생성을 확인합니다.

# Step 4. WAS 인증서 설정

아래 명령어로 WAS 컨테이너에 접속합니다.
```
docker exec -it pls-was bash
```

새로운 인증서 생성을 위해 **setting.sh** 파일을 실행합니다.
```
bash setting.sh
```

**exit** 명령어로 컨테이너 접속을 해제한 후, 적용을 위해 컨테이너를 재시작합니다.
```
docker restart pls-was
```

# Step 5. 접속 및 확인

- [WEB](https://localhost) *알람 권한 설정 팝업이 뜨면 허용해주세요.*
- [WAS](https://localhost:40000) *컨테이너 실행(재실행) 후, 30초~1분간 접속이 불가능할 수 있습니다.*
- [API DOCS](https://localhost:40000/docs)   
- [API DOCS(redoc)](https://localhost:40000/redoc)   