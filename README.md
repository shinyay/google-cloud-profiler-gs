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

#### List of available versions
```shell script
$ gsutil ls "gs://cloud-profiler/java/cloud-profiler-*"
```

### Containerize App with Agent
We can containerize Java Agent with **Dockerfile** and **Jib**.

#### Dockerfile

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
