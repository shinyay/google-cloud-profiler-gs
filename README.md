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

|Agent Option|Description|
|------------|-----------|
|-cprof_service|Service Name to identify on Cloud Profiler|

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

#### Jib

### Build Container Image

### Deploy to Cloud Run

```shell script
$ gcloud run deploy hello-spring \                                                                                                                                                      2021-02-02 12:22
  --image=us-central1-docker.pkg.dev/(gcloud config get-value project)/shinyay-docker-repo/hello-profile:1.0.0 \
  --no-allow-unauthenticated \
  --set-env-vars=JAVA_TOOL_OPTIONS=-agentpath:/opt/cprof/profiler_java_agent.so=-logtostderr,-cprof_enable_heap_sampling=true \
  --platform=managed
```

## Demo

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
