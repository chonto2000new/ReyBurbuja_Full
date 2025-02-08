// device_detection.js
function isMobileDevice() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Envía el resultado a Godot
if (isMobileDevice()) {
    Module.notifyGodot("mobile");
} else {
    Module.notifyGodot("desktop");
}