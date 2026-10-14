from django.db import models

# Cada clase es una tabla que ya existe en PostgreSQL (la crea
# sql/01_esquema.sql). managed = False le dice a Django que NO cree ni
# modifique esas tablas con migraciones: solo las lee y escribe.
# db_table es el nombre exacto de la tabla y db_column el de la columna.


class Funcionario(models.Model):
    cedula = models.IntegerField(unique=True)
    nombre = models.CharField(max_length=255)
    activo = models.BooleanField(default=True)

    class Meta:
        managed = False
        db_table = "funcionario"

    def __str__(self):
        return f"{self.nombre} ({self.cedula})"


class Usuario(models.Model):
    funcionario = models.OneToOneField(
        Funcionario, on_delete=models.DO_NOTHING, db_column="id_funcionario"
    )
    hash_password = models.CharField(max_length=255)
    rol = models.IntegerField()

    class Meta:
        managed = False
        db_table = "usuario"


class Horario(models.Model):
    funcionario = models.ForeignKey(
        Funcionario, on_delete=models.DO_NOTHING, db_column="id_funcionario"
    )
    fecha = models.DateField()
    entrada = models.TimeField()
    salida = models.TimeField()

    class Meta:
        managed = False
        db_table = "horario"


class Registro(models.Model):
    INGRESO = 1
    SALIDA = 2

    funcionario = models.ForeignKey(
        Funcionario, on_delete=models.DO_NOTHING, db_column="id_funcionario"
    )
    horario = models.ForeignKey(
        Horario, on_delete=models.DO_NOTHING, db_column="id_horario"
    )
    justificacion = models.CharField(max_length=255, blank=True, default="")
    observaciones = models.TextField(blank=True, default="")
    desvio = models.IntegerField()  # minutos, positivo = tarde
    motivo = models.IntegerField()  # 1 = ingreso, 2 = salida
    marca = models.CharField(max_length=255, null=True)

    class Meta:
        managed = False
        db_table = "registro"
