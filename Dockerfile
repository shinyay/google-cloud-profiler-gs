FROM gradle:6.5.1-jdk11 as java-build
WORKDIR /app/
COPY --chown=gradle:gradle . .
RUN gradle assemble --no-daemon
# Un-pack the uber-JAR
RUN mkdir -p build/libs/dependency && (cd build/libs/dependency; jar -xf ../*.jar)
# Non-root user
RUN adduser --system --home /var/cache/bootapp --shell /sbin/nologin bootapp;

#FROM gcr.io/distroless/java:11
FROM openjdk:11.0.10
ARG DEPENDENCY=/app/build/libs/dependency
COPY --from=java-build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=java-build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=java-build ${DEPENDENCY}/BOOT-INF/classes /app
# Java Agent
RUN mkdir -p /opt/cprof && \
  wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz \
  | tar xzv -C /opt/cprof
# Non-root user
COPY --from=java-build /etc/passwd /etc/shadow /etc/
USER bootapp
# Java Option
#   -XX:+PrintFlagsFinal : Display all options and their values used by the JVM
#   -XshowSettings:vm : Display the settings of the JVM
ENV _JAVA_OPTIONS "-agentpath:/opt/cprof/profiler_java_agent.so=-logtostderr,-cprof_enable_heap_sampling=true -XX:MaxRAMPercentage=80 -XX:MinRAMPercentage=50 -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8"
# Run Java with a classpath definition instead of a link to a JAR
ENTRYPOINT ["java","-cp","app:app/lib/*","com.google.shinyay.GoogleCloudProfilerGsApplicationKt"]