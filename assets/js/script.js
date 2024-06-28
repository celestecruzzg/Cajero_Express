document.getElementById('numeroTarjeta').addEventListener('input', function (e) {
    let value = e.target.value.replace(/\s+/g, ''); // Elimina todos los espacios
    value = value.replace(/\D/g, '');
    if (value.length > 0) {
        // Agrupa en 4 dígitos
        value = value.match(/.{1,4}/g).join(' ');
    }
    e.target.value = value;
});

document.getElementById('nip').addEventListener('input', function(e) {
    let value = e.target.value;
    value = value.replace(/\D/g, ''); // Eliminar todo lo que no sea dígito
    e.target.value = value;
});