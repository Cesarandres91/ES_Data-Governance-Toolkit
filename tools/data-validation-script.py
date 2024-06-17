# data-validation-script.py

import pandas as pd
import re
from datetime import datetime
import logging

# Configuración básica del logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load_data(file_path):
    """ Carga los datos desde un archivo CSV a un DataFrame de pandas. """
    try:
        data = pd.read_csv(file_path)
        logging.info("Datos cargados correctamente.")
        return data
    except FileNotFoundError:
        logging.error(f"No se encontró el archivo: {file_path}")
    except pd.errors.ParserError:
        logging.error("Error al parsear el archivo CSV.")
    return None

def validate_emails(emails):
    """ Valida que los correos electrónicos estén en un formato adecuado. """
    pattern = r'^\S+@\S+\.\S+$'
    return emails.apply(lambda x: bool(re.match(pattern, x)))

def validate_dates(dates, date_format="%Y-%m-%d"):
    """ Valida que las fechas estén en el formato correcto. """
    try:
        pd.to_datetime(dates, format=date_format)
        return True
    except ValueError:
        logging.error(f"Formato de fecha incorrecto. Se esperaba {date_format}.")
        return False

def validate_data(df):
    """ Realiza validaciones complejas en el DataFrame. """
    if df is None:
        return False

    validations = True

    # Validación de datos faltantes
    if df.isnull().values.any():
        missing_info = df.isnull().sum()
        logging.warning(f"Hay datos faltantes en el DataFrame:\n{missing_info}")
        validations = False

    # Validación de datos duplicados
    if df.duplicated().any():
        logging.warning("Se encontraron registros duplicados.")
        validations = False

    # Validaciones específicas de columnas
    if 'email' in df.columns and not validate_emails(df['email']).all():
        logging.warning("Hay correos electrónicos en formato incorrecto.")
        validations = False

    if 'date' in df.columns and not validate_dates(df['date']):
        validations = False

    return validations

def main():
    file_path = 'path_to_your_data.csv'  # Ajusta la ruta al archivo de datos
    
    data = load_data(file_path)
    if data is not None and validate_data(data):
        logging.info("Validación de datos exitosa.")
    else:
        logging.info("La validación de datos ha fallado.")

if __name__ == '__main__':
    main()
