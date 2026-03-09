#!/bin/bash
# HELENA v17.5 - FORJADOR DE REPOSITÓRIOS
# OPERADOR: SR. JOSÉ DIVINO

echo -e "\e[1;33m[HELENA]\e[0m Iniciando criação de novo território no GitHub..."

# 1. Dados de Acesso
read -p "Cole seu TOKEN (PAT) do GitHub: " TOKEN
read -p "Digite o nome do NOVO repositório: " REPO_NAME

# 2. Comando via API para criar o repositório remotamente
echo -e "\e[1;34m[INFO]\e[0m Solicitando criação ao GitHub..."
curl -H "Authorization: token $TOKEN" \
     -d "{\"name\":\"$REPO_NAME\", \"private\":false, \"auto_init\":true}" \
     https://api.github.com/user/repos > /dev/null

# 3. Configuração Local e Soldagem
cd ~/HELENA_CENTRAL
git init
git branch -M main
git remote add origin https://$TOKEN@github.com/pradodalapa-hue/$REPO_NAME.git 2>/dev/null || \
git remote set-url origin https://$TOKEN@github.com/pradodalapa-hue/$REPO_NAME.git

# 4. Push Inicial (O Nascimento)
git add .
git commit -m "HELENA v17.5 - NASCIMENTO DO SISTEMA [$REPO_NAME]"
git push -u origin main --force

echo -e "\e[1;32m[SUCESSO]\e[0m Repositório '$REPO_NAME' criado e sincronizado!"
