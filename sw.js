self.addEventListener('fetch', (event) => {
    const url = new URL(event.request.url);
    if (url.pathname.includes('.sistema/kernel.dat')) {
        const ref = event.request.referrer;
        if (!ref || (!ref.includes('8080') && !ref.includes('pradodalapa-hue'))) {
            event.respondWith(new Response("ACESSO NEGADO JDP", { status: 403 }));
            return;
        }
    }
    event.respondWith(fetch(event.request));
});
