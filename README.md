# CNCF Kubernetes Ansible Role

This repository is dedicated to provisioning a vanillia Kubernetes install on Linux-based systems.

# Installation Instructions

### 1.) Run Ansible Playbook

# APPENDIX KNOWLEDGE

<details>
<summary>What is the Purpose of the `kubelet-config.yaml` and `kubelet.conf`?</summary>

#### kubelet-config.yaml:

This file defines the configuration for the kubelet process itself.

It includes settings such as which container runtime to use, resource limits, node labels, eviction policies, and other operational parameters for the kubelet. It is typically specified using the `--config` flag in the kubelet service file. Common settings in this file include:
- apiVersion: Which version of the KubeletConfiguration API to use.
- kind: Always set to KubeletConfiguration.
- address: The IP address for the kubelet to listen on.
- authentication: Contains options related to how the kubelet authenticates with the API server.
- cgroupDriver: Defines which cgroup driver to use.

This file tunes the behavior of kubelet itself.

#### kubelet.conf:

The `kubelet.conf` file provides kubelet's credentials and configuration for communicating with the Kubernetes API server. It is typically generated during the execution of kubeadm init and contains the kubelet's configuration for connecting to the cluster - including the cluster's API server endpoint, authentication information (like certificates), and kubeconfig settings. 

### Do I Need Both kubelet-config.yaml and kubelet.conf?

Yes, both files are needed for different purposes when running the kubelet as a systemd service on Ubuntu (or any other system):

- `kubelet-config.yaml` is essential for configuring how the kubelet operates (runtime settings).
- `kubelet.conf` is required for kubelet to authenticate and interact with the API server (control plane).

To summarize, `kubelet-config.yaml` provides operational settings for kubelet (e.g., runtime, networking, resource limits).
`kubelet.conf` provides kubelet's access configuration to the Kubernetes API server (authentication, kubeconfig).
</details>