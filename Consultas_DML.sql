use [TurismoCabrera_DB]
go

--CONSULTAS DML
--CONSULTA 1: rELACION ENTRE CLIENTE Y RESERVA
select C.Nombre,C.Telefono,C.Documento_identidad,R.Fecha_reserva,R.Monto_estimado
from CLIENTE AS C
INNER JOIN RESERVA AS R
ON C.ID_CLIENTE= R.Id_cliente

--CONSULTA 2: MOstramos datos que comiencen A o terminen en "s".
SELECT *
FROM CLIENTE
WHERE Nombre like 'A%' or Nombre like '%s'

--CONSULTA 3:Mostrar las cotizaciones con el nombre del cliente y el tipo de servicio
select C.Nombre,C.Telefono,C.Tipo_cliente,CO.ID_Tarifa,CO.Monto,S.Fecha_inicio,S.Hora_salida
from CLIENTE as C
INNER JOIN COTIZACION AS CO
ON C.ID_CLIENTE = CO.ID_Cotizacion
INNER JOIN SERVICIO AS S
ON CO.Id_cliente=S.ID_servicio

--CONSULTA 4: Mostrar los servicios junto con los viajes programados.
SELECT S.ID_servicio, S.Tipo_servicio,S.Destino, V.ID_Viaje, V.Fecha,
       V.Hora_Salida, V.Hora_Llegada, V.Estado
FROM SERVICIO AS S
INNER JOIN VIAJE AS V
ON S.ID_servicio = V.ID_servicio
WHERE V.Estado = 'Programado'

--CONSULTA 5: Mostrar los conductores asignados a cada servicio.
SELECT C.ID_Conductor, C.Nombres, C.Apellidos,
       C.Licencia, S.ID_servicio, S.Tipo_servicio
FROM CONDUCTOR AS C
INNER JOIN SERVICIO_CONDUCTOR AS SC
ON C.ID_Conductor = SC.ID_Conductor
INNER JOIN SERVICIO AS S
ON SC.ID_servicio = S.ID_servicio

--CONSULTA 6:utilizamos LEFT JOIN para conservar todos los clientes
SELECT C.ID_CLIENTE, C.Nombre,R.ID_reserva, R.Estado, R.Monto_estimado
FROM CLIENTE AS C
LEFT JOIN RESERVA AS R
ON C.ID_CLIENTE = R.Id_cliente

--CONSULTA 7: utilizamos RIGHT JOIN para conservar todos los contratos
SELECT C.ID_Contrato, C.Estado, C.Monto,P.ID_Pago, P.Forma_Pago, P.Monto
FROM PAGO AS P
RIGHT JOIN CONTRATO AS C
ON P.ID_Contrato = C.ID_Contrato

--CONSULTA 8:el FULL JOIN conserva los registros de ambas tablas.
SELECT C.ID_Contrato, C.Estado, P.ID_Pago, P.Forma_Pago
FROM CONTRATO AS C
FULL JOIN PAGO AS P
ON C.ID_Contrato = P.ID_Contrato
WHERE C.ID_Contrato IS NULL OR P.ID_Pago IS NULL

--CONSULTA 9:Mostrar los servicios que tienen una duración de más de un día y cuyo destino es Cusco o Colca.
SELECT ID_servicio, Tipo_servicio,Fecha_inicio, Fecha_final, Destino
FROM SERVICIO
WHERE Fecha_final > Fecha_inicio AND (Destino = 'Cusco' OR Destino = 'Colca')

--CONSULTA 10: se utilizan varias condiciones y BETWEEN para delimitar un intervalo de fechas.
SELECT ID_Cotizacion, Id_cliente,Id_servicio, Fecha, Monto, Estado
FROM COTIZACION
WHERE Estado = 'Aceptada'
AND Monto > 1000 AND Fecha BETWEEN '2026-05-01' AND '2026-05-31'

--CONSULTA 11:Aumentar 5% el precio base y el precio por kilometro de las tarifas activas de tipo Turismo.
SELECT Nombre_tarifa, Tipo, Precio_Base, Precio_Por_Kilometro 
FROM TARIFA 
UPDATE TARIFA SET Precio_Base = Precio_Base + (Precio_Base * 0.05),
Precio_Por_Kilometro = Precio_Por_Kilometro + (Precio_Por_Kilometro * 0.05)
WHERE Tipo = 'Turismo' AND Estado = 'Activo'

--CONSULTA 12:Confirmar las reservas pendientes que piden factura y dejar constancia en las observaciones.
SELECT ID_reserva, Estado, Observaciones 
FROM RESERVA
UPDATE RESERVA SET Estado = 'Confirmada',
Observaciones = Observaciones + ' - Pago confirmado'
WHERE Estado = 'Pendiente' AND Observaciones LIKE '%factura%'
--CONSULTA 13: Muestres todos los Proveedores ordenados de forma ascendente
SELECT * FROM CLIENTE
ORDER BY ID_CLIENTE ASC
--CONSULTA 14:
SELECT * FROM PASAJERO
ORDER BY ID_Pasajero DESC
--CONSULTA 15: Eliminamos fila mientras apellido sea igual a 'Pérez'
DELETE FROM PASAJERO
WHERE Apellidos='Pérez'
--CONSULTA 16:Unir dos columnas
Select *
from PASAJERO

SELECT Nombres+' '+Apellidos as [NOMBRE COMPLETO], Documento_identidad, Telefono
FROM PASAJERO
--CONSULTA 17: descuento de tarifa del 10% si tipo precio es mayor a 300

select Tipo, Precio_Base, Precio_Por_Kilometro
from TARIFA
UPDATE TARIFA SET Precio_Base = Precio_Base-(Precio_Base*0.1)
WHERE Tipo = 'Corporativo'

--CONSULTA 18:Aumentar 5% el precio base y el precio por kilometro de las
-- tarifas activas de tipo Turismo.
SELECT Nombre_tarifa, Tipo,Precio_Base,Precio_Por_Kilometro, Precio_Base +(Precio_Base*0.05) AS AUMENTOBASE, Precio_Por_Kilometro+(Precio_Por_Kilometro*0.05) AS AUMENTOKILO 
from TARIFA
WHERE TIPO = 'Corporativo'
select * from TARIFA

--CONSULTA 19:DE LA TABLA PAGO MOSTRAR LOS PRODUCTOS DE MAYOR PRECIO
--CONVERTIMOS A SUBCONSULTA
SELECT * FROM PAGO
SELECT MIN(Monto)
FROM PAGO

--CONSULTA 20:Desactivar las promociones activas cuya fecha de fin ya paso.
SELECT Nombre_Promocion, Estado, Fecha_Fin FROM PROMOCION
UPDATE PROMOCION SET Estado = 'Inactivo'
WHERE Fecha_Fin < GETDATE() AND Estado = 'Activo'
