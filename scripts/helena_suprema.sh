#!/bin/bash
# HELENA v40.0 SUPREME - ARQUITETURA JDP
# OPERADOR: SR. JOSÉ DIVINO PRADO DA LAPA

echo -e "\e[1;33m[SISTEMA JDP]\e[0m INICIANDO LINHA DE MONTAGEM SUPREMA..."

# 1. ENTRADA DE DADOS
read -p "NOME DO NOVO SISTEMA: " PROJ_NAME
read -p "COLE SEU TOKEN (PAT): " TOKEN
USER_GH="pradodalapa-hue"

# 2. FORJANDO IDENTIDADE (KERNEL.DAT)
echo -e "\e[1;34m[1/5]\e[0m Criando Núcleo de Segurança (.sistema)..."
mkdir -p .sistema img scripts
CHAVE_UNICA=$(date +%s | sha256sum | head -c 24)
echo "PROJETO=$PROJ_NAME" > .sistema/kernel.dat
echo "CHAVE=$CHAVE_UNICA" >> .sistema/kernel.dat
echo "OPERADOR=JOSE_DIVINO" >> .sistema/kernel.dat
echo "STATUS=NUCLEO_ATIVO" >> .sistema/kernel.dat

# 3. CRIAÇÃO AUTOMÁTICA DO REPOSITÓRIO
echo -e "\e[1;34m[2/5]\e[0m Criando Repositório no GitHub via API..."
curl -H "Authorization: token $TOKEN" \
     -d "{\"name\":\"$PROJ_NAME\", \"private\":false}" \
     https://api.github.com/user/repos > /dev/null

# 4. SOLDAGEM INDUSTRIAL PWA
echo -e "\e[1;34m[3/5]\e[0m Aplicando Motores PWA (Manifest e SW)..."
# Executa o motor que injeta os códigos no index.html
~/HELENA_CENTRAL/scripts/motor.sh

# 5. SINCRONIZAÇÃO E PUSH GLOBAL
echo -e "\e[1;34m[4/5]\e[0m Subindo Sistema para a Nuvem..."
git init
git branch -M main
git remote add origin https://$TOKEN@github.com/$USER_GH/$PROJ_NAME.git 2>/dev/null || \
git remote set-url origin https://$TOKEN@github.com/$USER_GH/$PROJ_NAME.git
git add .
git commit -m "HELENA SUPREME v40.0 - SISTEMA: $PROJ_NAME"
git push -u origin main --force

# 6. FINALIZAÇÃO E ENTREGA DO LINK
echo -e "\e[1;32m[5/5] MISSÃO CUMPRIDA, SR. JOSÉ!\e[0m"
echo "----------------------------------------------------"
echo "SISTEMA: $PROJ_NAME"
echo "KERNEL ID: $CHAVE_UNICA"
echo "LINK DO REPOSITÓRIO: https://github.com/$USER_GH/$PROJ_NAME"
echo "LINK DO SISTEMA: https://$USER_GH.github.io/$PROJ_NAME/"
echo "----------------------------------------------------"
