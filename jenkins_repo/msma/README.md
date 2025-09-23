

---

# 🚀 multi-stage-multi-agent Jenkins Pipeline Explained
---

## 📋 Overview

This Jenkins declarative pipeline uses **Docker containers** to isolate build environments per stage, ensuring clean and reproducible builds. It runs backend and frontend build steps inside respective Docker images and runs Docker CLI commands on the Jenkins host.

---

## ⚙️ Pipeline Structure

```groovy
pipeline {
  agent none
  stages {
    // stages defined here
  }
}
```

* **`pipeline`**: Root block defining the pipeline script.
* **`agent none`**: No global Jenkins agent. Each stage defines its own environment.

---

## 🏗️ Stage 1: Back-end

```groovy
stage('Back-end') {
  agent {
    docker { image 'maven:3.8.1-adoptopenjdk-11' }
  }
  steps {
    sh 'mvn --version'
  }
}
```

* Runs inside **Maven + OpenJDK 11** container.
* Verifies Maven installation by printing version.

---

## 🌐 Stage 2: Front-end

```groovy
stage('Front-end') {
  agent {
    docker { image 'node:17-alpine' }
  }
  steps {
    sh 'node --version'
  }
}
```

* Runs inside **Node.js 17 Alpine** container.
* Checks Node.js version for validation.

---

## 🐳 Stage 3: Docker Commands

```groovy
stage('dockercommands') {
  agent any
  steps {
    sh 'docker --version'
    sh 'docker ps'
  }
}
```

* Runs **on the Jenkins host agent** (not inside a container).
* Prints Docker version and lists running Docker containers.
* **Requires Docker installed and accessible on the host.**

---

## 🔑 Key Highlights

| Feature                        | Explanation                                                           |
| ------------------------------ | --------------------------------------------------------------------- |
| **Agent per stage**            | Each stage runs in its own environment (Docker container or agent).   |
| **Docker container isolation** | Clean, consistent builds with pre-configured environments.            |
| **Host Docker commands**       | Docker CLI commands executed directly on Jenkins host for management. |

---

## 📝 Summary

| Stage Name         | Environment                 | Purpose                         |
| ------------------ | --------------------------- | ------------------------------- |
| **Back-end**       | Maven + AdoptOpenJDK Docker | Build and verify backend tools  |
| **Front-end**      | Node.js Alpine Docker       | Build and verify frontend tools |
| **dockercommands** | Jenkins Host (any agent)    | Run Docker CLI commands on host |

---

## 🚀 Get Started

1. Ensure Jenkins agents have Docker installed and configured.
2. Place this Jenkinsfile in your project repo.
3. Trigger the pipeline in Jenkins.
4. Enjoy clean and consistent builds powered by Docker!

---
<img width="3840" height="2669" alt="Untitled diagram _ Mermaid Chart-2025-09-23-121102" src="https://github.com/user-attachments/assets/dc7f8c94-96f6-47ba-8ec5-308b3100d69b" />

