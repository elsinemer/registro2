// Este archivo se ejecuta en el navegador: recoge la cédula y la acción,
// y envía ambos datos al servidor Django para validar y guardar la marca.

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
const subtractButton = document.getElementById("subtractButton");

let resetTimer;
let enviando = false;


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


function formatCi(cedula) {
  return `${cedula.slice(0, 1)}.${cedula.slice(1, 4)}.${cedula.slice(4, 7)}-${cedula.slice(7)}`;
}


function showErrorMessage(texto) {
  errorMessage.textContent = texto;
  identificationInput.classList.toggle("invalid", Boolean(texto));
}


function validateIdentification(showError = false) {
  const completa = /^\d{8}$/.test(identificationInput.value);
  actionHint.hidden = !completa;
  userPreview.textContent = completa
    ? `Cédula ${formatCi(identificationInput.value)}`
    : "";
  if (showError && !completa) {
    showErrorMessage("Debe ingresar los ocho números de la cédula.");
  } else {
    showErrorMessage("");
  }
  return completa;
}


async function postJson(url, contenido) {
  const respuesta = await fetch(url, {
    method: "POST",
    credentials: "same-origin",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(contenido),
  });

  let datos;
  try {
    datos = await respuesta.json();
  } catch {
    throw new Error(`El servidor no devolvió una respuesta válida (${respuesta.status}).`);
  }
  if (!respuesta.ok || !datos.ok) {
    throw new Error(datos.mensaje || "No se pudo completar la operación.");
  }
  return datos;
}


async function saveRecord() {
  return postJson("/registrar/", {});
}


async function registerMark(tipo) {
  if (enviando) return;
  if (!validateIdentification(true)) {
    identificationInput.focus();
    return;
  }

  const cedula = identificationInput.value;
  enviando = true;
  addButton.disabled = true;
  subtractButton.disabled = true;
  showErrorMessage("");

  try {
    const datos = await postJson("/fichar/", { cedula, tipo });
    const diferencia = Number(datos.diferencia);
    if (!Number.isFinite(diferencia)) {
      throw new Error("El servidor no informó un desvío válido.");
    }

    // Cinco minutos o más de diferencia requieren indicar un motivo.
    if (Math.abs(diferencia) >= 5) {
      window.location.assign(datos.url_excepcion || "/excepciones/");
      return;
    }

    await saveRecord();
    showSuccess(cedula, datos);
  } catch (error) {
    showErrorMessage(error.message || "No se pudo conectar con el servidor.");
  } finally {
    enviando = false;
    addButton.disabled = false;
    subtractButton.disabled = false;
  }
}


function showSuccess(cedula, datos) {
  document.getElementById("successLabel").textContent = `${datos.movimiento} registrado`;
  document.getElementById("successTitle").textContent =
    `${datos.tipo === "salida" ? "Hasta luego" : "Bienvenido/a"}, ${datos.nombre}`;
  document.getElementById("successMovement").textContent = datos.movimiento;
  const mensaje = datos.mensaje || "Marca guardada correctamente.";
  document.getElementById("successResult").textContent =
    mensaje.charAt(0).toLocaleUpperCase("es-UY") + mensaje.slice(1);
  document.getElementById("successCi").textContent = formatCi(cedula);
  document.getElementById("successTime").textContent = datos.marca;

  accessPanel.hidden = true;
  successPanel.hidden = false;
  clearTimeout(resetTimer);
  resetTimer = setTimeout(resetScreen, 5000);
}


function resetScreen() {
  identificationInput.value = "";
  validateIdentification(false);
  successPanel.hidden = true;
  accessPanel.hidden = false;
  requestAnimationFrame(() => identificationInput.focus());
}


identificationInput.addEventListener("input", () => {
  identificationInput.value = identificationInput.value.replace(/\D/g, "").slice(0, LARGO_CEDULA);
  validateIdentification(false);
});

identificationInput.addEventListener("blur", () => validateIdentification(true));
accessForm.addEventListener("submit", (event) => {
  event.preventDefault();
  validateIdentification(true);
  identificationInput.focus();
});

addButton.addEventListener("click", (event) => {
  event.preventDefault();
  registerMark("ingreso");
});

subtractButton.addEventListener("click", (event) => {
  event.preventDefault();
  registerMark("salida");
});

document.addEventListener("keydown", (event) => {
  if (accessPanel.hidden) return;

  if (event.key === "+" || event.code === "NumpadAdd") {
    event.preventDefault();
    registerMark("ingreso");
    return;
  }
  if (event.key === "-" || event.code === "NumpadSubtract") {
    event.preventDefault();
    registerMark("salida");
    return;
  }

  if (
    document.activeElement === identificationInput &&
    !event.ctrlKey && !event.metaKey && !event.altKey &&
    event.key.length === 1 && !/[0-9]/.test(event.key)
  ) {
    event.preventDefault();
  }
});

updateDateTime();
setInterval(updateDateTime, 1000);
