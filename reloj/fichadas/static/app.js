// Este archivo se ejecuta en el navegador de la persona, no en el servidor.
// La lista de personas y sus horarios NO esta aca: vive en la base de
// datos y la consulta el backend. Este archivo solo junta la cedula y se la manda.

const LARGO_CEDULA = 8;

const clock = document.getElementById("clock");
const date = document.getElementById("date");
const accessForm = document.getElementById("accessForm");
const identificationInput = document.getElementById("identificationInput");
const errorMessage = document.getElementById("errorMessage");
const actionHint = document.getElementById("actionHint");
const userPreview = document.getElementById("userPreview");
const accessPanel = document.getElementById("accessPanel");
const successPanel = document.getElementById("successPanel");
const addButton = document.getElementById("addButton");

let resetTimer;
let enviando = false;


// Reloj y fecha visibles en la pantalla.
function updateDateTime() {
  const ahora = new Date();

  clock.textContent = ahora.toLocaleTimeString("es-UY", {
    timeZone: "America/Montevideo",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  });

  date.textContent = ahora.toLocaleDateString("es-UY", {
    timeZone: "America/Montevideo",
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}


// Muestra la cédula con puntos y guion.
function formatCi(cedula) {
  return (
    `${cedula.slice(0, 1)}.` +
    `${cedula.slice(1, 4)}.` +
    `${cedula.slice(4, 7)}-` +
    cedula.slice(7)
  );
}


// Muestra un mensaje de error.
function showErrorMessage(texto) {
  errorMessage.textContent = texto;
  identificationInput.classList.toggle("invalid", Boolean(texto));
}


// Comprueba que se hayan escrito ocho números.
function validateIdentification(showError = false) {
  const cedula = identificationInput.value;
  const completa = /^\d{8}$/.test(cedula);

  actionHint.hidden = !completa;
  userPreview.textContent = completa
    ? `Cédula ${formatCi(cedula)}`
    : "";

  if (showError && !completa) {
    showErrorMessage("Debe ingresar los ocho números de la cédula.");
  } else {
    showErrorMessage("");
  }

  return completa;
}


// Envía una solicitud y comprueba la respuesta del servidor.
async function postJson(url, contenido) {
  const respuesta = await fetch(url, {
    method: "POST",
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(contenido),
  });

  let datos;

  try {
    datos = await respuesta.json();
  } catch {
    throw new Error(
      `El servidor no devolvió una respuesta válida (${respuesta.status}).`
    );
  }

  if (!respuesta.ok || !datos.ok) {
    throw new Error(datos.mensaje || "No se pudo completar la operación.");
  }

  return datos;
}


// Guarda la marca pendiente que el servidor conserva en la sesión.
async function saveRecord() {
  return postJson("/registrar/", {});
}


// Consulta el horario y decide si debe abrir excepciones.
async function registerEntry() {
  if (enviando) {
    return;
  }

  if (!validateIdentification(true)) {
    identificationInput.focus();
    return;
  }

  const cedula = identificationInput.value;

  enviando = true;
  addButton.disabled = true;
  showErrorMessage("");

  try {
    // El backend del paquete usa la hora del servidor en Uruguay.
    const datos = await postJson("/fichar/", { cedula });

    const diferencia = Number(datos.diferencia);

    if (!Number.isFinite(diferencia)) {
      throw new Error("El servidor no informó un desvío válido.");
    }

    // Desde cinco minutos de adelanto o retraso, abre excepciones.
    if (Math.abs(diferencia) >= 5) {
      window.location.assign("/excepciones/");
      return;
    }

    // Entre -4 y +4 minutos, guarda directamente.
    await saveRecord();
    showSuccess(cedula, datos);

  } catch (error) {
    showErrorMessage(
      error.message || "No se pudo conectar con el servidor."
    );
  } finally {
    enviando = false;
    addButton.disabled = false;
  }
}


// Muestra la bienvenida después de confirmar el guardado.
function showSuccess(cedula, datos) {
  document.getElementById("successLabel").textContent =
    "Ingreso registrado";

  document.getElementById("successTitle").textContent =
    `Bienvenido, ${datos.nombre}`;

  document.getElementById("successMovement").textContent =
    "Ingreso";

  const mensaje = datos.mensaje || "Ingreso guardado correctamente.";

  document.getElementById("successResult").textContent =
    mensaje.charAt(0).toUpperCase() + mensaje.slice(1);

  document.getElementById("successCi").textContent =
    formatCi(cedula);

  document.getElementById("successTime").textContent =
    datos.llegada;

  accessPanel.hidden = true;
  successPanel.hidden = false;

  clearTimeout(resetTimer);
  resetTimer = setTimeout(resetScreen, 5000);
}


// Vuelve a la pantalla de ingreso.
function resetScreen() {
  identificationInput.value = "";
  validateIdentification(false);

  successPanel.hidden = true;
  accessPanel.hidden = false;

  requestAnimationFrame(() => identificationInput.focus());
}


// Permite únicamente ocho dígitos.
identificationInput.addEventListener("input", () => {
  identificationInput.value = identificationInput.value
    .replace(/\D/g, "")
    .slice(0, LARGO_CEDULA);

  validateIdentification(false);
});


identificationInput.addEventListener("blur", () => {
  validateIdentification(true);
});


// Evita que Enter recargue la página.
accessForm.addEventListener("submit", (event) => {
  event.preventDefault();
  validateIdentification(true);
  identificationInput.focus();
});


// Botón de ingreso.
addButton.addEventListener("click", (event) => {
  event.preventDefault();
  registerEntry();
});


// Tecla + del teclado común o numérico.
document.addEventListener("keydown", (event) => {
  if (accessPanel.hidden) {
    return;
  }

  if (event.key === "+" || event.code === "NumpadAdd") {
    event.preventDefault();
    registerEntry();
    return;
  }

  if (
    document.activeElement === identificationInput &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.altKey &&
    event.key.length === 1 &&
    !/[0-9]/.test(event.key)
  ) {
    event.preventDefault();
  }

  // Tecla - del teclado común o numérico.
document.addEventListener("keydown", (event) => {
  if (accessPanel.hidden) {
    return;
  }

  if (event.key === "-" || event.code === "NumpadSubtract") {
    event.preventDefault();
    registerEntry();
    return;
  }

  if (
    document.activeElement === identificationInput &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.altKey &&
    event.key.length === 1 &&
    !/[0-9]/.test(event.key)
  ) {
    event.preventDefault();
  }
});


// Inicio.
updateDateTime();
setInterval(updateDateTime, 1000);
validateIdentification(false);
identificationInput.focus();