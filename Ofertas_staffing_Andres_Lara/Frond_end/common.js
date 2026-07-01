async function limpiarBackendStore() {
    const base = (typeof API_BASE !== 'undefined') ? API_BASE : (window.location.protocol === 'file:' ? 'http://127.0.0.1:5000' : '');
    try {
        await fetch(`${base}/api/cliente`, {
            method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({})
        });
        await fetch(`${base}/api/seleccionados`, {
            method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ perfiles: [] })
        });
        await fetch(`${base}/api/descripcion`, {
            method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ perfiles: [] })
        });
    } catch (err) {
        console.warn('No se pudo limpiar el backend:', err);
    }
}

function limpiarAlmacenLocal() {
    try { localStorage.clear(); sessionStorage.clear(); } catch (e) {}
}

function cerrarSesion() {
    // No esperamos la limpieza del backend para evitar bloqueos si el servidor no responde.
    limpiarBackendStore();
    limpiarAlmacenLocal();
    const base = (typeof API_BASE !== 'undefined') ? API_BASE : '';
    if (base) {
        window.location.href = base + '/';
    } else {
        window.location.href = './Login.html';
    }
}

function generarOfertaNueva() {
    // Lanzar limpieza en segundo plano y redirigir de inmediato
    limpiarBackendStore();
    limpiarAlmacenLocal();
    window.location.href = './index.html';
}
