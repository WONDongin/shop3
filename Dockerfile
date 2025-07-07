# Dockerfile : shop3 프로젝트 폴더에 생성
#즉, 이 Dockerfile은 멀티 스테이지 빌드를 활용해서
# ✔ 빌드(컴파일)와 ✔ 실행(런타임)을
# 분리한 효율적인 도커 이미지 생성 방식
# 1단계: 빌드 환경
FROM openjdk:17-jdk-slim as builder
# 현재 shop3 전체를 app로 복사
WORKDIR /app
COPY . .
# mvnw 파일에 실행 권한 부여
RUN chmod +x mvnw
# mvnw : 빌드 수행 가능. 빌드 수행
RUN ./mvnw clean package -Dmaven.test.skip=true

# 2단계: 실제 런타임 환경
FROM openjdk:17-jdk-slim
WORKDIR /app
# shop3-0.0.1-SNAOSHOT.jar : 빌드로 생성된 jar 파일
# app.jar 빌드된 파일의 이름 설정
COPY --from=builder /app/target/shop3-0.0.1-SNAPSHOT.jar app.jar
# 포트 번호 정의. application.properties에 정의된 포트와 동일해야 함
EXPOSE 8080
# 명령문으로 컨테이너가 실행됨
ENTRYPOINT ["java", "-jar", "app.jar"]
