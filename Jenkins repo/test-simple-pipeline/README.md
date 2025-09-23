
Simple script for a **Declarative Jenkins Pipeline** that uses a **Docker container (Node.js 16 Alpine)** to run a simple test step. Here's a quick breakdown, validation, and how to use it.

---

### ✅ **Your Pipeline Explaination**

```groovy
pipeline {
  agent {
    docker { image 'node:16-alpine' }
  }
  stages {
    stage('Test') {
      steps {
        sh 'node --version'
      }
    }
  }
}
```

#### 🔍 What it does:

* **`agent` block**: Specifies the environment to run the pipeline in. This uses a **Docker container** with the `node:16-alpine` image.
* **`stage('Test')`**: Defines a pipeline stage named "Test".
* **`steps` block**: Runs the shell command `node --version` inside the container, which prints the Node.js version.

---

### ✅ Requirements for this to work:

1. **Docker must be installed and running** on the Jenkins agent.
2. Jenkins must have **permission to run Docker containers**.
3. You should be using a Jenkins setup that supports **Docker-based agents** (e.g., **Docker plugin** or **Pipeline with Docker support**).

---

### 📁 Where to place this pipeline?

If you're putting it in your GitHub repo:

* Create a file named:

  ```
  Jenkinsfile
  ```

* Paste your code into that file and commit it to the repo.

---

### 🚀 Triggering the Pipeline in Jenkins

1. Go to your Jenkins dashboard.
2. Create a **Pipeline project**.
3. Under **Pipeline Definition**, select **"Pipeline script from SCM"**.
4. Choose **Git**, and enter the GitHub repo URL.
5. Jenkins will look for the `Jenkinsfile` and run it when triggered.

---

### 🧪 Optional: Add More Stages

Want to expand? Here's an example with `Install` and `Build` stages:

```groovy
pipeline {
  agent {
    docker { image 'node:16-alpine' }
  }
  stages {
    stage('Install') {
      steps {
        sh 'npm install'
      }
    }
    stage('Test') {
      steps {
        sh 'npm test'
      }
    }
    stage('Build') {
      steps {
        sh 'npm run build'
      }
    }
  }
}
```

---

