FROM alpine as Docker-Alpine
USER root

ARG USERNAME=jenkins
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USER_GROUP=$USERNAME
ARG USER_HOME=/home/jenkins

# Set to false to skip installing zsh and Oh My ZSH!
ARG VERSION=ver_2.0.0
ENV BASE_VERSION="${VERSION}"

# Timezone
RUN apk add -q --update --no-cache tzdata
ENV TZ=Europe/Kiev

# VSCode specific (speed up setup)
RUN apk add -q --update --no-cache libstdc++

# TODO: Configure apt and install packages COPY обеденить
COPY ./build /tmp/build

RUN \
    # ✔️ bash Install
    /bin/ash /tmp/build/scripts/bash.sh \
    # ✔️ Common
    && /bin/ash /tmp/build/scripts/common-alpine.sh "$USERNAME" "$USER_UID" "$USER_GID" "$USER_GROUP" "$USER_HOME" \
    # ✔️ ZSH Install
    && /bin/ash /tmp/build/scripts/zsh-alpine.sh "$USERNAME" "$USER_GID" "$USER_HOME" \
    # ✔️ Docker Install
    && /bin/bash /tmp/build/scripts/docker-alpine.sh "$USERNAME" \
    # ✔️ java Install
    && /bin/bash /tmp/build/scripts/java-alpine.sh \
    # ✔️ Clean up
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/build \
    && rm /var/cache/apk/*
#------------------------------------------------#
# 👉               Jenkins                  👈  #
#------------------------------------------------#
ARG http_port=8080
ARG agent_port=50000
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV REF $REF

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dpermissive-script-security.enabled=true"

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals

COPY ./jenkins /tmp/install

RUN /bin/bash /tmp/install/apk.sh \
    #  ✔️ Jenkins
    && /bin/bash /tmp/install/jenkins.sh "$USERNAME" "$USER_GROUP" "$REF" "$JENKINS_HOME"\
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/install

VOLUME $JENKINS_HOME

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers && \
      groupdel docker && \
      groupadd -g 497 docker && \
      usermod -aG docker jenkins

COPY --chown=${USERNAME}:${USER_GROUP} ./jenkins/resources/*.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY --chown=${USERNAME}:${USER_GROUP} ./jenkins/resources/jenkins.properties $JENKINS_HOME

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER $USERNAME

RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

EXPOSE ${http_port}
EXPOSE ${agent_port}

# Add Tini https://github.com/krallin/tini
#RUN apk add --no-cache tini && chmod +x /sbin/tini
#ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
