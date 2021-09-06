# prophet

## 활용방법(순서대로)
1. Docker 다운로드 및 빌드 또는 docker hub에서 pull
    - prophet까지 빌드된 버전
2. 테스트 데이터 host에 다운로드
3. host의 테스트 데이터 폴더를 도커 컨테이너에서 마운트
4. 도커 컨테이너에서 prophet 실행  

----------

## prophet 빌드된 docker 획득하기
- 방법 1이나 방법 2 중 택일

### 방법 1.Docker 다운로드 및 빌드
- Dockefile 다운로드
- 빌드
    ```
    docker build Dockerfile
    ```
- 빌드 과정에서 prophet까지 빌드됨

### 방법 2.
- docker hub에서 pull
    ```
    docker pulldocker pull jeminya/prophet:0.1
    ```
  
-----------
## 테스트 데이터를 host에 다운로드
- https://www.cs.toronto.edu/~fanl/program_repair/scenarios/에서 gzip-f17cbd13a1d0a7.tar.gz 다운로드
-  예
    ```
    cp gzip-f17cbd13a1d0a7.tar.gz /Users/user/data
    mkdir gzip-f17cbd13a1d0a7
    tar xvf gzip-f17cbd13a1d0a7.tar.gz -C gzip-f17cbd13a1d0a7
    ```

-----------
## host의 테스트 데이터 폴더를 도커 컨테이너에서 마운트
```
docker run -ti --mount type=bind,source=/Users/user/data,destination=/home/workspace/data prophet:0.1 
```
-----------

## 도커 컨테이너에서 prophet 실행
1. revlog 파일 편집
    - 예
    ```
    root@123456789012:/home/workspace/data# cat gzip-f17cbd13a1d0a7.revlog
    -
    -
    Diff Cases: Tot 1
    6
    Positive Cases: Tot 2
    2 3
    Regression Cases: Tot 0
    ```
   
2. conf 파일 편집
    - 예
    ```
    root@123456789012:/home/workspace# cat gzip-f17cbd13a1d0a7.conf
    revision_file=/home/workspace/data/gzip-f17cbd13a1d0a7.revlog
    src_dir=/home/workspace/data/gzip-f17cbd13a1d0a7/gzip-case-f17cbd13a1d0a7/gzip-src
    test_dir=/home/workspace/prophet/benchmarks/gzip-tests
    build_cmd=/home/workspace/prophet/tools/gzip-build.py
    test_cmd=/home/workspace/prophet/tools/gzip-test.py
    localizer=profile
    bugged_file=gzip.c
    fixed_out_file=gzip-fix-f17cbd13a1d0a7.c
    ```
3. prophet 실행
    - 예
    ```
    root@123456789012:/home/workspace# prophet -feature-para /home/workspace/prophet/crawler/para-all.out /home/workspace/gzip-f17cbd13a1d0a7.conf -r gzip_workspace -first-n-loc 200 -skip-verify -consider-all
    ```