args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

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
