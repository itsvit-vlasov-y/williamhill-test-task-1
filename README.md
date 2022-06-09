Task 1 - Solution from IT Svit
===

```
#  ┬  ┬─┐┌┌┐┌─┐┌┐┐    ┬┬ ┐o┌─┐┬─┐
#  │  ├─ ││││ ││││  ┌ ││ │││  ├─ 
#  ┘─┘┴─┘┘ ┘┘─┘┘└┘  └─┘┘─┘┘└─┘┴─┘
```

- [Task 1 - Solution from IT Svit](#task-1---solution-from-it-svit)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Manual launch](#manual-launch)
  - [Automated launchstartation, just launch `start.sh`](#automated-launchstartation-just-launch-startsh)

## Description

This is a simple infrastructure code for running Nginx with couple scripts. This solves the task #1 from **WilliamHill DevOps Challenge**.

## Requirements

1. [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
2. [Install Helm](https://helm.sh/docs/intro/install/)
3. [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
4. [Install Docker](https://docs.docker.com/engine/install/)

## Manual launch

1. Start the cluster
  
  Execute the following:

  ```shell
  minikube start
  ```

  Check that the cluster is up and reachable.

  ```shell
  minikube status
  kubectl get no -o wide
  ```

2. Build the image

  ```shell
  docker build -t juice:1.22.0 images/juice
  ```

3. Load the image to the minikube's containerd

  ```shell
  minikube image load juice:1.22.0
  ```

4. Install the chart

  ```shell
  helm upgrade --install \
		--create-namespace \
		--namespace development \
		--values environment/development/values.yaml \
		lemon-juice charts/lemon
  ```

5. Check connectivity

  ```shell
  minikube service list
  ```

  Output of the service list will help you to find out the URL that you have to open in order to access the application. It should be similar to:

  ```
  |-------------|-------------|--------------|-----------------------------|
  |  NAMESPACE  |    NAME     | TARGET PORT  |             URL             |
  |-------------|-------------|--------------|-----------------------------|
  | default     | kubernetes  | No node port |
  | development | lemon-juice | http/80      | http://192.168.59.100:31037 |
  | kube-system | kube-dns    | No node port |
  |-------------|-------------|--------------|-----------------------------|
  ```

  Here we can see, that in my case URL is `http://192.168.59.100:31037`

6. Open in browser or `curl`

  ```shell
  curl -D- 'http://192.168.59.100:31037'
  ```

## Automated launchstartation, just launch `start.sh`

```shell
sh ./start.sh
```

To stop the cluster, there is a `stop.sh` script present.

```shell
sh ./stop.sh
```
