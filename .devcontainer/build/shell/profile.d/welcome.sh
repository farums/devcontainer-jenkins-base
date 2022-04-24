
echo -e "Welcome ${RED}`whoami` ${CYAN}Jenkins${NC} 17.04.2021"
echo "`git --version`"
echo -e "${CYAN}MyZsh${NC} version 2.0.0"
echo -e ${CYAN}PATH${NC} = `echo $PATH`
type -a code &> /dev/null && echo  -e "${CYAN}VS code server${NC} `code -v | head -n 1`"

echo -e "${CYAN}Jenkins${NC} логин: ${JENKINS_ADMIN_ID} password: ${JENKINS_ADMIN_PASSWORD}"