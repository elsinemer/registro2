import json
from datetime import datetime

from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.utils import timezone
from django.views.decorators.http import require_GET
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from .models import Funcionario, Horario, Registro


# Una "vista" en Django es una funcion que recibe la consulta que llego
# (request) y devuelve la respuesta. Se conectan con una direccion en urls.py.


def index(request):
    """Muestra el teclado numerico."""
    # render() busca el template, lo procesa y devuelve el HTML.
    # Encuentra index.html solo porque 'fichadas' esta en INSTALLED_APPS.
    return render(request, "index.html")


def buscar_horario(cedula, fecha):
    """Busca al funcionario y su horario del dia de "fecha".

    Devuelve (funcionario, horario, None) si esta todo bien, o
    (None, None, "mensaje de error") si algo falta.
    """
    # .filter(...).first() devuelve None si no hay ninguno, en vez de romper.
    funcionario = Funcionario.objects.filter(cedula=cedula).first()
    if funcionario is None:
        return None, None, "La cédula no está registrada."
    if not funcionario.activo:
        return None, None, "El funcionario está dado de baja."

    horario = Horario.objects.filter(funcionario=funcionario, fecha=fecha.date()).first()
    if horario is None:
        return None, None, "No tiene horario cargado para hoy."

    return funcionario, horario, None


def calcular_desvio(horario, fecha):
    """Minutos entre la hora de entrada del horario y la marca (positivo = tarde)."""
    # Pasamos las dos horas a "minutos desde la medianoche" para poder
    # restarlas como numeros comunes:  08:10 -> 8 * 60 + 10 = 490
    minutos_esperados = horario.entrada.hour * 60 + horario.entrada.minute
    minutos_llegada = fecha.hour * 60 + fecha.minute
    return minutos_llegada - minutos_esperados


# @require_POST rechaza con un 405 todo lo que no sea POST (urls.py no
# filtra metodos, asi que esto va aca).
# @csrf_exempt desactiva la proteccion CSRF de Django. Es temporal: sin esto
# el fichaje seria rechazado con un 403 porque no mandamos ningun token.
@csrf_exempt
@require_POST
def fichar(request):
    """Recibe {"cedula", "fecha"} y compara con el horario de ese dia."""
    # request.body es el texto crudo que mando app.js. Django no convierte
    # el JSON solo, asi que lo hacemos nosotros.
    datos = json.loads(request.body)
    cedula = datos["cedula"]
    fecha = timezone.localtime(timezone.now()).replace(second=0, microsecond=0)

    funcionario, horario, error = buscar_horario(cedula, fecha)
    if error:
        print(f"[{fecha:%d/%m/%Y %H:%M}] Cedula {cedula}: {error}")
        return JsonResponse({"ok": False, "mensaje": error})

    diferencia = calcular_desvio(horario, fecha)

    # El signo de la resta decide el mensaje.
    if diferencia > 0:
        mensaje = f"llego {diferencia} minutos tarde"
    elif diferencia < 0:
        mensaje = f"llego {-diferencia} minutos temprano"
    else:
        mensaje = "llego a horario"

    # Por ahora el aviso sale por la terminal donde corre el servidor.
    print(
        f"[{fecha:%d/%m/%Y %H:%M}] {funcionario.nombre} ({cedula}): {mensaje} "
        f"(esperado {horario.entrada:%H:%M}, llego {fecha:%H:%M})"
    )

    request.session["ingreso_pendiente"] = {
        "cedula": str(cedula), "fecha": fecha.isoformat(),
        "nombre": funcionario.nombre, "esperado": f"{horario.entrada:%H:%M}",
        "llegada": f"{fecha:%H:%M}", "desvio": diferencia,
        "tipo": "Llegada tarde" if diferencia > 0 else "Llegada anticipada",
    }

    return JsonResponse(
        {
            "ok": True,
            "nombre": funcionario.nombre,
            "esperado": f"{horario.entrada:%H:%M}",
            "llegada": f"{fecha:%H:%M}",
            "diferencia": diferencia,
            "requiere_excepcion": abs(diferencia) >= 5,
            "url_excepcion": "/excepciones/",
            "mensaje": mensaje,
        }
    )


@csrf_exempt
@require_POST
def registrar(request):
    """Recibe {"cedula", "fecha"} y guarda el ingreso en la tabla registro."""
    datos = json.loads(request.body)
    pendiente = request.session.get("ingreso_pendiente")
    if not pendiente:
        return JsonResponse({"ok": False, "mensaje": "No hay un ingreso pendiente."}, status=400)
    fecha = datetime.fromisoformat(pendiente["fecha"])
    datos["cedula"] = pendiente["cedula"]
    requiere = abs(pendiente["desvio"]) >= 5
    motivos = {"Reunión de profesores", "Llegada tarde", "Llegada anticipada",
               "Cambio de horario", "Cambio de día y horario de coordinación", "Otros"}
    justificacion = datos.get("motivo", "") if requiere else ""
    observaciones = datos.get("observaciones", "") if requiere else ""
    if requiere and justificacion not in motivos:
        return JsonResponse({"ok": False, "mensaje": "Seleccione un motivo."}, status=400)
    if not isinstance(observaciones, str) or len(observaciones) > 1000:
        return JsonResponse({"ok": False, "mensaje": "Observaciones inválidas."}, status=400)

    # El desvio lo calcula el backend de nuevo, no se confia en el que
    # pueda mandar el navegador.
    funcionario, horario, error = buscar_horario(datos["cedula"], fecha)
    if error:
        return JsonResponse({"ok": False, "mensaje": error})

    # .create() hace el INSERT y devuelve el registro ya guardado, con su id.
    registro = Registro.objects.create(
        funcionario=funcionario,
        horario=horario,
        desvio=calcular_desvio(horario, fecha),
        motivo=Registro.INGRESO,
        marca=pendiente["fecha"],
        justificacion=justificacion,
        observaciones=observaciones.strip(),
    )

    request.session.pop("ingreso_pendiente", None)
    print(f"Registro {registro.id} guardado: {funcionario.nombre}, desvio {registro.desvio} min")
    return JsonResponse({"ok": True, "id": registro.id})


@require_GET
def excepciones(request):
    pendiente = request.session.get("ingreso_pendiente")
    if not pendiente or abs(pendiente["desvio"]) < 5:
        return redirect("/")
    return render(request, "excepciones.html", {"ingreso": pendiente})
