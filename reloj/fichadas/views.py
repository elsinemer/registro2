import json
from datetime import datetime

from django.http import JsonResponse
from django.shortcuts import redirect, render
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST

from .models import Funcionario, Horario, Registro


def index(request):
    """Muestra la pantalla de ingreso y salida."""
    return render(request, "index.html")


def buscar_horario(cedula, fecha):
    """Devuelve (funcionario, horario, error) para la fecha de la marca."""
    funcionario = Funcionario.objects.filter(cedula=cedula).first()
    if funcionario is None:
        return None, None, "La cédula no está registrada."
    if not funcionario.activo:
        return None, None, "El funcionario está dado de baja."

    horario = Horario.objects.filter(funcionario=funcionario, fecha=fecha.date()).first()
    if horario is None:
        return None, None, "No tiene horario cargado para hoy."

    return funcionario, horario, None


def hora_esperada(horario, tipo):
    """Selecciona la hora de entrada o salida del horario."""
    return horario.entrada if tipo == "ingreso" else horario.salida


def calcular_desvio(horario, fecha, tipo="ingreso"):
    """Calcula marca menos hora prevista; positivo significa posterior."""
    esperada = hora_esperada(horario, tipo)
    minutos_esperados = esperada.hour * 60 + esperada.minute
    minutos_marca = fecha.hour * 60 + fecha.minute
    return minutos_marca - minutos_esperados


def describir_desvio(diferencia, tipo):
    if tipo == "ingreso":
        if diferencia > 0:
            return f"llegó {diferencia} minutos tarde"
        if diferencia < 0:
            return f"llegó {-diferencia} minutos antes"
        return "llegó a horario"

    if diferencia > 0:
        return f"salió {diferencia} minutos después del horario previsto"
    if diferencia < 0:
        return f"salió {-diferencia} minutos antes del horario previsto"
    return "salió a horario"


@csrf_exempt
@require_POST
def fichar(request):
    """Compara la marca recibida con la entrada o salida del horario."""
    try:
        datos = json.loads(request.body)
        if not isinstance(datos, dict):
            raise ValueError("El cuerpo JSON debe ser un objeto.")
        cedula = str(datos.get("cedula", ""))
        tipo = datos.get("tipo", "ingreso")
    except (json.JSONDecodeError, UnicodeDecodeError, ValueError):
        return JsonResponse({"ok": False, "mensaje": "La solicitud no es válida."}, status=400)

    if not cedula.isdigit() or not isinstance(tipo, str) or tipo not in {"ingreso", "salida"}:
        return JsonResponse({"ok": False, "mensaje": "Indique una cédula y un tipo de marca válidos."}, status=400)

    fecha = timezone.localtime(timezone.now()).replace(second=0, microsecond=0)
    funcionario, horario, error = buscar_horario(cedula, fecha)
    if error:
        print(f"[{fecha:%d/%m/%Y %H:%M}] Cédula {cedula}: {error}")
        return JsonResponse({"ok": False, "mensaje": error})

    diferencia = calcular_desvio(horario, fecha, tipo)
    esperada = hora_esperada(horario, tipo)
    mensaje = describir_desvio(diferencia, tipo)
    movimiento = "Ingreso" if tipo == "ingreso" else "Salida"

    print(
        f"[{fecha:%d/%m/%Y %H:%M}] {funcionario.nombre} ({cedula}): {mensaje} "
        f"(previsto {esperada:%H:%M}, marca {fecha:%H:%M})"
    )

    request.session["fichaje_pendiente"] = {
        "cedula": cedula,
        "fecha": fecha.isoformat(),
        "nombre": funcionario.nombre,
        "esperado": f"{esperada:%H:%M}",
        "marca": f"{fecha:%H:%M}",
        "desvio": diferencia,
        "tipo": tipo,
        "movimiento": movimiento,
    }

    return JsonResponse({
        "ok": True,
        "nombre": funcionario.nombre,
        "esperado": f"{esperada:%H:%M}",
        "marca": f"{fecha:%H:%M}",
        "llegada": f"{fecha:%H:%M}",  # Compatibilidad con la pantalla anterior.
        "diferencia": diferencia,
        "requiere_excepcion": abs(diferencia) >= 5,
        "url_excepcion": "/excepciones/",
        "tipo": tipo,
        "movimiento": movimiento,
        "mensaje": mensaje,
    })


@csrf_exempt
@require_POST
def registrar(request):
    """Guarda la marca pendiente y, si se requiere, su motivo y detalle."""
    pendiente = request.session.get("fichaje_pendiente")
    if not pendiente:
        return JsonResponse({"ok": False, "mensaje": "No hay una marca pendiente."}, status=400)

    try:
        datos = json.loads(request.body or b"{}")
        if not isinstance(datos, dict):
            raise ValueError("El cuerpo JSON debe ser un objeto.")
    except (json.JSONDecodeError, UnicodeDecodeError, ValueError):
        return JsonResponse({"ok": False, "mensaje": "La solicitud no es válida."}, status=400)

    fecha = datetime.fromisoformat(pendiente["fecha"])
    tipo = pendiente["tipo"]
    diferencia = int(pendiente["desvio"])
    requiere = abs(diferencia) >= 5
    motivos = {
        "Reunión de profesores",
        "Llegada tarde",
        "Llegada anticipada",
        "Salida anticipada",
        "Salida posterior",
        "Cambio de horario",
        "Cambio de día y horario de coordinación",
        "Otros",
    }
    justificacion = datos.get("motivo", "") if requiere else ""
    observaciones = datos.get("observaciones", "") if requiere else ""
    if requiere and (not isinstance(justificacion, str) or justificacion not in motivos):
        return JsonResponse({"ok": False, "mensaje": "Seleccione un motivo."}, status=400)
    if not isinstance(observaciones, str) or len(observaciones) > 1000:
        return JsonResponse({"ok": False, "mensaje": "Observaciones inválidas."}, status=400)

    funcionario, horario, error = buscar_horario(pendiente["cedula"], fecha)
    if error:
        return JsonResponse({"ok": False, "mensaje": error})

    # El valor motivo de la tabla identifica el tipo de marca: 1 ingreso, 2 salida.
    registro = Registro.objects.create(
        funcionario=funcionario,
        horario=horario,
        desvio=calcular_desvio(horario, fecha, tipo),
        motivo=Registro.INGRESO if tipo == "ingreso" else Registro.SALIDA,
        marca=pendiente["fecha"],
        justificacion=justificacion,
        observaciones=observaciones.strip(),
    )

    request.session.pop("fichaje_pendiente", None)
    print(
        f"Registro {registro.id} guardado: {pendiente['movimiento']} de "
        f"{funcionario.nombre}, desvío {registro.desvio} min"
    )
    return JsonResponse({"ok": True, "id": registro.id})


@require_GET
def excepciones(request):
    pendiente = request.session.get("fichaje_pendiente")
    if not pendiente or abs(int(pendiente["desvio"])) < 5:
        return redirect("/")
    return render(request, "excepciones.html", {"fichaje": pendiente})
