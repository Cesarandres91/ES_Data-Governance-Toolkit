# Configuración de Apache Atlas

## Introducción

Apache Atlas es un framework de gestión de metadatos que permite a las organizaciones gobernar sus datos de manera efectiva. Proporciona capacidades de catalogación, clasificación, y colaboración de metadatos, facilitando el cumplimiento de regulaciones de datos y mejorando la calidad de los datos.

## Requisitos Previos

Antes de comenzar con la configuración de Apache Atlas, asegúrate de cumplir con los siguientes requisitos previos:

- **JDK 8 o superior** instalado y configurado en tu sistema.
- **Apache Hadoop** y **HBase** configurados si planeas integrar Atlas con estos sistemas.
- **Apache Kafka**, que Atlas usa para mensajes entre componentes.

## Instalación de Apache Atlas

1. **Descarga de Apache Atlas**:
   Descarga la última versión de Apache Atlas desde el [sitio oficial de Apache Atlas](https://atlas.apache.org/#/).

2. **Descompresión del Archivo**:
   ```bash
   tar -xzf apache-atlas-<version>-bin.tar.gz
   cd apache-atlas-<version>
```

3. **Configuración Inicial**:
   Edita los archivos de configuración ubicados en `conf/` para ajustar la configuración a tu entorno específico, incluyendo la conexión a bases de datos y la configuración de Kafka.

## Configuración del Servidor Atlas

Atlas utiliza varios archivos de configuración, los cuales debes revisar y modificar según sea necesario:

- **atlas-application.properties**: Este es el principal archivo de configuración para los detalles del servicio, como ajustes de autenticación y configuraciones de conexión a bases de datos.
- **users-credentials.properties**: Para configurar usuarios y contraseñas.
- **log4j.xml**: Para ajustes de logging.

### Configuración Básica

En el archivo `atlas-application.properties`, configura las propiedades básicas:

```properties
atlas.graph.storage.hostname=localhost
atlas.graph.storage.port=9160
atlas.kafka.bootstrap.servers=localhost:9027
```
Estos valores son ejemplos básicos; debes ajustarlos según la arquitectura y políticas de tu organización.

## Integración con Hadoop y HBase

Para integrar Apache Atlas con Hadoop y HBase, asegúrate de que los servicios Hadoop y HBase estén ejecutándose y accesibles. En el archivo de configuración, establece las propiedades adecuadas para apuntar a tus instancias de Hadoop y HBase.

## Iniciar y Verificar el Servicio

Para iniciar Apache Atlas:

```bash
./bin/atlas_start.py
```
Verifica que el servicio esté corriendo accediendo a la interfaz de usuario web de Apache Atlas en http://<host>:21000/.



