# Cloud Profiler Getting Started

Cloud Profiler allows you to continuously profile CPU and heap usages.

- CPU Time
- Wall Time
- Heap

## Description
### Enable Cloud Profiler API
```shell script
$ gcloud services enable cloudprofiler.googleapis.com
```

### Java Agent
Cloud Profiler works by adding a Java agent to your JVM startup argument.
The agent can communicate with the Cloud Profiler service in the Cloud.

We can download it from Cloud Storage:
```shell script
$ curl https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz |tar zx -C src/main/jib/opt/cprof
```

#### List of Available Versions
```shell script
$ gsutil ls "gs://cloud-profiler/java/cloud-profiler-*"
```

#### Agent Configuration
When you load the Profiler agent, you specify a service-name argument and an optional service-version argument to configure it.

`-agentpath:INSTALL_DIR/profiler_java_agent.so=OPTION1,OPTION2,OPTION3`

The followings are typical options:

|Agent Option|Description|Default|
|------------|-----------|-------|
|-cprof_service|Service Name to identify on Cloud Profiler||
|-cprof_service_version|Service Version to identify on Cloud Profiler||
|-cprof_project_id|Google Cloud Project ID||
|-cprof_cpu_use_per_thread_timers|Most accurate CPU time profiles.<BR>Use of this option results in increased per-thread overhead.|false|
|-cprof_enable_heap_sampling (*1)|When you enable heap profiling, the sampling interval is set to 512 KiB by default.|false|
|-cprof_heap_sampling_interval|Sampling intervals from 256 KiB<BR>-cprof_heap_sampling_interval=262144<BR>Sampling intervals from 1024 KiB<BR>-cprof_heap_sampling_interval=1048576||

(*1)
To enable heap profiling for **Java 11 and higher**, set `-cprof_enable_heap_sampling=true`.
Heap profiling isn't supported for Java 10 and lower.

#### Agent Logging
The profiling agent can report logging information with `-logtostderr`

- `-logtostderr`: Enable writing logs to standard error

- `0`: Log all messages. Default logging level.
- `1`: Log warning, error, and fatal messages.
- `2`: Log error and fatal messages.
- `3`: Log only fatal messages and stop the application.

### Containerize App with Agent
We can containerize Java Agent with **Dockerfile** and **Jib**.

#### Dockerfile

- [Dockerfile](Dockerfile)

```dockerfile
FROM openjdk:11.0.10
RUN mkdir -p /opt/cprof && \
  wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz \
  | tar xzv -C /opt/cprof
```
##### Create Artifact Registry for Container
```shell script
$ gcloud artifacts repositories create shinyay-docker-repo --location us-central1 --repository-format docker
```

##### Build Container Image by Cloud Build

```shell script
$ gcloud builds submit --tag us-central1-docker.pkg.dev/(gcloud config get-value project)/shinyay-docker-repo/hello-profile:1.0.0
```

#### Jib
##### Add Arbitrary Files to the Image
We can put files as follows

- `src/main/jib/`FILES
- `src/main/jib/`DIRECTORIES/FILES

![agent-for-jib](https://user-images.githubusercontent.com/3072734/107008843-9592fd80-67d7-11eb-9c3f-6ed019cd3c7c.png)

[references](https://github.com/GoogleContainerTools/jib/blob/master/jib-maven-plugin/README.md#adding-arbitrary-files-to-the-image)

##### Build Container Image by Jib

```shell script
$ ./gradlew clean jib -Djib.to.image=gcr.io/(gcloud config get-value project)/hello-profile:1.0.0
```

### Deploy to Cloud Run
We don't have to configure JVM Arguments on Cloud Run ENVs

```shell script
$ gcloud run deploy hello-profile \
  --image=us-central1-docker.pkg.dev/(gcloud config get-value project)/shinyay-docker-repo/hello-profile:1.0.0 \
  --no-allow-unauthenticated \
  --platform=managed
```

#### The case of Configure JVM Arguments on Cloud Run

```shell script
$ gcloud run deploy hello-profile \
  --image=us-central1-docker.pkg.dev/(gcloud config get-value project)/shinyay-docker-repo/hello-profile:1.0.0 \
  --no-allow-unauthenticated \
  --platform=managed
  --set-env-vars=JAVA_TOOL_OPTIONS=-agentpath:/opt/cprof/profiler_java_agent.so=-logtostderr,-cprof_enable_heap_sampling=true \
```

## Demo
### Access Cloud Run Instance
```shell script
$ curl -H "Authorization: Bearer "(gcloud auth print-identity-token)"" \
    (gcloud run services describe hello-profile --format 'value(status.address.url)')/api/v1/hello
```

### Open Cloud Profiler
- [Cloud Profiler](https://console.cloud.google.com/profiler?_ga=2.172112163.1211938147.1612136098-983599867.1599137884)

![profler-for-heap](https://user-images.githubusercontent.com/3072734/106996668-b56cf600-67c4-11eb-9876-0d0f1fee25f7.png)

## Features

- feature:1
- feature:2

## Requirement

## Usage

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
