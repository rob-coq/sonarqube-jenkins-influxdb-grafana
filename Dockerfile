FROM jenkins/jenkins:2.289.1-jdk11

COPY docker-resources/plugins.txt /usr/share/jenkins/ref/plugins.txt
USER root
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN apt-get update && apt-get install -y \
  wget \
  zip \
  sudo
RUN mkdir /var/jenkins_home/.ssh && echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && ssh-keygen -q -t rsa -N '' -f /var/jenkins_home/.ssh/id_rsa
RUN curl -o bin_terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip && unzip -o bin_terraform.zip && mv terraform /usr/bin && rm -rf bin_terraform.zip
RUN curl -o bin_packer.zip https://releases.hashicorp.com/packer/1.6.6/packer_1.6.6_linux_amd64.zip && unzip bin_packer.zip && mv packer /usr/bin && rm -rf bin_packer.zip
USER jenkins

COPY docker-resources/jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
COPY docker-resources/sonarqubeGoodCodeJob.xml /usr/share/jenkins/ref/jobs/sonarqube-good-code/config.xml
COPY docker-resources/sonarqubeBadCodeJob.xml /usr/share/jenkins/ref/jobs/sonarqube-bad-code/config.xml

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
