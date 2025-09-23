Multi-stage-multi-agent Jenkins pipeline :

Overall Pipeline Structure

pipeline {
  agent none
  stages {
    // stages go here
  }
}


pipeline: This is the root block defining the whole Jenkins Pipeline script.

agent none: This means no default agent (executor) is assigned to the whole pipeline. Each stage will specify its own agent where it should run.

Stage: Back-end
stage('Back-end') {
  agent {
    docker { image 'maven:3.8.1-adoptopenjdk-11' }
  }
  steps {
    sh 'mvn --version'
  }
}


stage('Back-end'): Defines a stage named Back-end.

agent { docker { image '...' } }: This tells Jenkins to run the steps inside a Docker container using the maven:3.8.1-adoptopenjdk-11 image.

steps: The actual commands to execute in this stage.

sh 'mvn --version': Runs mvn --version inside the container, which checks the Maven version. This validates Maven is available and working.

Stage: Front-end
stage('Front-end') {
  agent {
    docker { image 'node:17-alpine' }
  }
  steps {
    sh 'node --version'
  }
}


Similar structure to the Back-end stage.

Runs inside a node:17-alpine Docker container.

Executes node --version to verify Node.js is installed and its version.

Stage: dockercommands
stage('dockercommands') {
  agent any
  steps {
    sh 'docker --version'
    sh 'docker ps'
  }
}


agent any: Run this stage on any available Jenkins agent (doesn’t use Docker).

Steps:

docker --version: Prints Docker version installed on the Jenkins agent.

docker ps: Lists running Docker containers on the host machine.

Note: This stage requires that Docker is installed and accessible on the Jenkins agent machine itself, not inside a Docker container.

Key points:

Agent none + per-stage agents: This is useful if different stages need different environments or tools.

Using Docker agents: Each build stage spins up a Docker container with the specified image to run commands. This makes your builds clean and consistent.

dockercommands stage runs on host: Since it uses agent any (not Docker), it accesses the host machine’s Docker daemon.

Summary:

pipeline runs these steps:

Build or test backend code using Maven in a Maven+Java container.

Build or test frontend code using Node.js in a Node container.

Run Docker commands (docker --version and docker ps) on the Jenkins agent host.
