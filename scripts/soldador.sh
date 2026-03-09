#!/bin/bash
# HELENA v16.7 - MOTOR DE SOLDAGEM INDUSTRIAL
# OPERADOR: SR. JOSÉ DIVINO

echo -e "\e[1;33m[HELENA]\e[0m Iniciando Soldagem..."

# 1. Verificar se existe index.html
if [ ! -f "index.html" ]; then
    echo -e "\e[1;31m[ERRO]\e[0m Cade o index.html, Sr. Jose? Coloque ele na pasta raiz."
    exit 1
fi

# 2. Gerar o MANIFEST.JSON automaticamente
cat << 'EOT' > manifest.json
{
    "name": "SISTEMA HELENA SOBERANA",
    "short_name": "HELENA_JDP",
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

# 3. Gerar o SERVICE WORKER (sw.js)
cat << 'EOT' > sw.js
const CACHE_NAME = 'helena-v16.7';
self.addEventListener('install', e => {
    e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(['./', './index.html', './manifest.json'])));
});
self.addEventListener('fetch', e => {
    e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
EOT

# 4. Injetar a conexão de segurança no index.html
# Procura o final do head e injeta o link do manifest
sed -i '/<\/head>/i \    <link rel="manifest" href="manifest.json">\n    <meta name="theme-color" content="#ffde57">' index.html

# Procura o final do body e injeta o registro do Service Worker
sed -i '/<\/body>/i \    <script>\n        if ("serviceWorker" in navigator) navigator.serviceWorker.register("./sw.js");\n    <\/script>' index.html

echo -e "\e[1;32m[SUCESSO]\e[0m Soldagem concluida. O index.html agora e um PWA Soberano."
