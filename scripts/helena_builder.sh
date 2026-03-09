#!/bin/bash
# HELENA v29.5 - MOTOR SOBERANO COM AUTO-PAGES
# OPERADOR: SR. JOSÉ DIVINO

echo -e "\e[1;33m[HELENA]\e[0m Iniciando Soldagem e Ativação de Hospedagem..."

# 1. LIMPEZA TOTAL DA PISTA
cd ~/HELENA_CENTRAL
rm -rf .git index.html sw.js manifest.json .sistema
mkdir -p .sistema

# 2. ENTRADA DO PRODUTO (KERNEL)
echo -e "\e[1;34m[PASSO 1]\e[0m Cole o HTML do seu projeto e pressione \e[1;32mCTRL+D\e[0m:"
cat > ~/HELENA_CENTRAL/.sistema/kernel.dat

# 3. DADOS DE OPERAÇÃO
read -p "NOME DO PROJETO: " PROJ_NAME
read -p "ID DE ACESSO (Ex: 8080): " ID_JDP
read -p "LINK DO ÍCONE: " IMG_LINK
read -p "COLE SEU TOKEN (PAT): " TOKEN
USER_GH="pradodalapa-hue"

# 4. GERAÇÃO DOS ARQUIVOS (SW, INDEX, MANIFEST)
cat <<EOM > ~/HELENA_CENTRAL/sw.js
self.addEventListener('fetch', (event) => {
    const url = new URL(event.request.url);
    if (url.pathname.includes('.sistema/kernel.dat')) {
        const ref = event.request.referrer;
        if (!ref || (!ref.includes('$ID_JDP') && !ref.includes('$USER_GH'))) {
            event.respondWith(new Response("ACESSO NEGADO JDP", { status: 403 }));
            return;
        }
    }
    event.respondWith(fetch(event.request));
});
EOM

cat <<EOM > ~/HELENA_CENTRAL/index.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SISTEMA JDP - SEGURANÇA HELENA</title>
    <style>
        body { background: #020305; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; font-family: sans-serif; overflow: hidden; }
        .pulse { animation: p 1.5s infinite; color: #f59e0b; font-size: 12px; letter-spacing: 2px; text-align: center; }
        @keyframes p { 0%, 100% { opacity: 0.3; } 50% { opacity: 1; } }
        #error-screen { display: none; position: fixed; inset: 0; background: #fff; flex-direction: column; align-items: center; justify-content: center; text-align: center; z-index: 10000; }
    </style>
</head>
<body>
    <div id="loading" class="pulse"><h2>SINC. HELENA SECURITY...</h2></div>
    <div id="error-screen">
        <div style="font-size: 80px">🦖</div>
        <h1 style="color: #202124; font-size: 22px; font-weight: 500;">Não há conexão com a Internet</h1>
        <p style="color: #5f6368; font-size: 14px;">Verifique os cabos de rede, o modem e o roteador.</p>
        <span style="color: #1a73e8; font-size: 13px;">ERR_INTERNET_DISCONNECTED</span>
    </div>
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const id_pedido = urlParams.get('acesso') || urlParams.get('id');
        if (!id_pedido) { ativarModoFantasma(); } else {
            const script = document.createElement('script');
            script.src = \`http://localhost:9090/gtm.js?id=\${id_pedido}\`;
            script.onload = () => {
                navigator.serviceWorker.register('sw.js').then(() => {
                    fetch('.sistema/kernel.dat').then(r => r.text()).then(html => {
                        document.open(); document.write(html); document.close();
                    });
                });
            };
            script.onerror = () => { ativarModoFantasma(); };
            document.head.appendChild(script);
        }
        function ativarModoFantasma() {
            document.getElementById('loading').style.display = 'none';
            document.getElementById('error-screen').style.display = 'flex';
        }
    </script>
</body>
</html>
EOM

cat <<EOM > ~/HELENA_CENTRAL/manifest.json
{
  "name": "$PROJ_NAME",
  "short_name": "JDP",
  "start_url": "index.html?acesso=$ID_JDP",
  "display": "standalone",
  "background_color": "#020305",
  "theme_color": "#f59e0b",
  "icons": [{ "src": "$IMG_LINK", "sizes": "192x192", "type": "image/png" }]
}
EOM

# 5. CRIAR REPOSITÓRIO E ATIVAR PAGES VIA API
echo -e "\e[1;34m[PASSO 2]\e[0m Preparando terreno no GitHub..."
curl -H "Authorization: token $TOKEN" -d "{\"name\":\"$PROJ_NAME\", \"private\":false}" https://api.github.com/user/repos > /dev/null
sleep 2

# 6. SINCRONIZAÇÃO GITHUB
git init
git remote add origin https://$TOKEN@github.com/$USER_GH/$PROJ_NAME.git 2>/dev/null || git remote set-url origin https://$TOKEN@github.com/$USER_GH/$PROJ_NAME.git
git add .
git commit -m "HELENA v29.5 - ENTREGA COMPLETA"
git branch -M main
git push -u origin main --force

# 7. LIGAR O INTERRUPTOR DO SITE (GITHUB PAGES)
echo -e "\e[1;34m[PASSO 3]\e[0m Ativando hospedagem automática..."
curl -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
     https://api.github.com/repos/$USER_GH/$PROJ_NAME/pages \
     -d '{"source":{"branch":"main","path":"/"}}' > /dev/null

echo -e "\n\e[1;32m[SUCESSO] MÁQUINA MONTADA E LINK ATIVO!\e[0m"
echo -e "ACESSO (Aguarde 2 min): https://$USER_GH.github.io/$PROJ_NAME/?acesso=$ID_JDP"
