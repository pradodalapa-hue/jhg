#!/bin/bash
# HELENA v17.0 - MOTOR SUPREMO DE SOLDAGEM
# OPERADOR: SR. JOSÉ DIVINO PRADO DA LAPA

echo -e "\e[1;33m[SISTEMA JDP]\e[0m Iniciando Processo de Soldagem Industrial..."

# 1. VERIFICAÇÃO DE MATÉRIA-PRIMA
if [ ! -f "index.html" ]; then
    echo -e "\e[1;31m[ERRO]\e[0m index.html não encontrado na raiz!"
    exit 1
fi

# 2. EXTRAÇÃO DE DADOS DO KERNEL (Identidade do Inquilino)
if [ -f ".sistema/kernel.dat" ]; then
    NOME_PROJETO=$(grep "PROJETO=" .sistema/kernel.dat | cut -d'=' -f2)
    VERSAO=$(grep "VERSAO=" .sistema/kernel.dat | cut -d'=' -f2)
    echo -e "\e[1;34m[INFO]\e[0m Vinculando ao Kernel: $NOME_PROJETO (v$VERSAO)"
else
    echo -e "\e[1;31m[AVISO]\e[0m Kernel.dat ausente! Usando configuração padrão."
    NOME_PROJETO="SISTEMA_SOBERANO"
fi

# 3. GERAÇÃO DO MANIFESTO (A Identidade Visual)
cat << EOT > manifest.json
{
    "name": "$NOME_PROJETO",
    "short_name": "JDP_SISTEMAS",
    "start_url": "index.html",
    "display": "standalone",
    "background_color": "#050506",
    "theme_color": "#ffde57",
    "icons": [
        { "src": "img/icon-192.png", "sizes": "192x192", "type": "image/png" },
        { "src": "img/icon-512.png", "sizes": "512x512", "type": "image/png" }
    ]
}
EOT

# 4. SOLDAGEM DO SERVICE WORKER (O Motor Offline)
cat << EOT > sw.js
const CACHE_NAME = 'jdp-cache-v$(date +%s)';
const assets = ['./', './index.html', './manifest.json'];

self.addEventListener('install', e => {
    e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(assets)));
});

self.addEventListener('fetch', e => {
    e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
EOT

# 5. INJEÇÃO DE CÓDIGO NO INDEX.HTML (Sem estragar o original)
# Adiciona as tags de PWA antes do fechamento do </head>
sed -i '/<\/head>/i \    <link rel="manifest" href="manifest.json">\n    <meta name="theme-color" content="#ffde57">\n    <meta name="mobile-web-app-capable" content="yes">' index.html

# Adiciona o script do Service Worker antes do fechamento do </body>
sed -i '/<\/body>/i \    <script>\n        if ("serviceWorker" in navigator) {\n            navigator.serviceWorker.register("./sw.js");\n        }\n    <\/script>' index.html

echo -e "\e[1;32m[SUCESSO]\e[0m Soldagem Concluída! O sistema está pronto e blindado."
