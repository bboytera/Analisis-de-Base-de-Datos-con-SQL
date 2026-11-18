# Inventario y facturación con MySQL

Proyecto formativo con datos de ejemplo. Consultas sobre productos, clientes y facturas; no representa resultados de un cliente real.

## Ejecución

Requiere MySQL 8.0.16 o posterior. Crear una base vacía y ejecutar desde MySQL Shell en modo SQL o el cliente mysql:

```sql
SOURCE CREATE_TABLES.sql;
SOURCE insert_clients.sql;
SOURCE insert_products.sql;
SOURCE insert_bills.sql;
SOURCE insert_bill_products.sql;
SOURCE SELECT.sql;
```

El esquema no borra tablas existentes. Usar una base nueva; los INSERT originales usan IGNORE y no constituyen una migración idempotente. Revisar SHOW WARNINGS después de cada carga.

## Correcciones

- sku declarado como VARCHAR; columnas stock, price, discount y date_added incluidas según los INSERT y las consultas.
- Claves foráneas activas y tipos UNSIGNED compatibles. Restricciones para precios, cantidades y descuentos.
- SELECT.sql contiene consultas ejecutables; las salidas pegadas anteriores están separadas en RESULTADOS_ORIGINALES.md.
- Total por factura = SUM(quantity * precio histórico de la línea * (1 - discount/100)). No se toma el precio actual del catálogo.
- discount se expresa de 0 a 100. El valor de stock no está incluido en los INSERT originales: empieza en 0. Los valores históricos de inventario no se pueden reproducir sin una fuente de existencias; no se inventan.
- number_of_lines cuenta líneas, no unidades; para unidades debe usarse SUM(quantity).

DIAGRAMA.pdf es un recurso histórico: el esquema autoritativo corregido es CREATE_TABLES.sql.

## Validación

La validación realizada se documenta en VALIDACION.md. Las cifras del README anterior fueron retiradas para no confundir resultados históricos con una nueva ejecución.

## Pruebas de regresión

```powershell
python -m unittest discover -p "test_*.py" -v
```

Consultar VALIDACION.md para distinguir pruebas con datos reales, sintéticos y límites de integración.
