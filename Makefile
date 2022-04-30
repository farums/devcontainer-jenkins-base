#!/usr/bin/make
Tag=1.0
ProjectName=Jenkins
################################################################################
# 👉                         ⚙️Makefile Jenkins                              👈 #
################################################################################
include ./Make/Settings/*.mk
help-all: #Help: Запуск всех Help
	@$(MAKE) help.Settings
################################################################################
# 👉                             jenkins                                   👈 #
################################################################################
#https://github.com/jenkinsci/docker/blob/4fa9ebc13069fa8186728622cd63702cddf11162/jenkins.sh
install:
	xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
	$(MAKE) init
init:
	/usr/local/bin/jenkins.sh
home:
	cd /var/jenkins_home
user:
	@whoami
ref:
	 ls -a /usr/share/jenkins/ref/
password:
	@cat /var/jenkins_home/.jenkins/secrets/initialAdminPassword
jenkins_home:
	@code /var/jenkins_home/
################################################################################
# 👉                             Install                                   👈 #
################################################################################
mc:
	apk add mc
################################################################################
# 👉                             clear                                     👈 #
################################################################################
clear: ## Чиска докера.
	@docker system prune
	@docker container prune
	@docker volume prune
	#@docker rmi $(docker images -a -q) -f
	@docker system df
################################################################################
# 👉                          🔑 git                                       👈 #
################################################################################
ECHO_GIT=$(ProjectName):$(Tag): GIT
GitCommit=$(call args, $(ProjectName):$(Tag))
git: ## GIT  
	@status=$$(git status --porcelain); \
	if [ ! -z "$${status}" ]; \
	then \
		echo "🌍 Eсть изменение фиксируем 📒$(ECHO_GIT)"; \
		echo "📒$(ECHO_GIT) 📄 Add "   && git add .; \
		echo "📒$(ECHO_GIT) 📄 Commit" && git commit -m "♻️ make: $(GitCommit)"; \
		echo "📒$(ECHO_GIT) 📄 Push"   && git push -u origin master; \
		echo "✅ Exit $(ECHO_GIT)"; \
	fi
gitmodules: ## GIT gitmodules
	@$(MAKE) git GitCommit=$(GitCommit)
git-tag:
	@echo "📒 GIT tag"             && git tag -a $(Tag) -m "my version  $(Tag)"
	@echo "📒 GIT push tag $(Tag)" && git push origin $(Tag)
	@echo "📒 GIT tag list " && git tag -l
################################################################################
# 👉                                                                       👈 #
################################################################################