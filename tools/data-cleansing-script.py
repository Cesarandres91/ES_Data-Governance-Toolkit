# data-cleansing-script.py

import pandas as pd
import numpy as np
import logging

# Configuración del logger para capturar información del proceso
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load_data(file_path):
    """ Carga los datos desde un archivo CSV a un DataFrame de pandas. """
    try:
        df = pd.read_csv(file_path)
        logging.info("Datos cargados correctamente.")
        return df
    except FileNotFoundError:
        logging.error(f"Archivo no encontrado: {file_path}")
    except pd.errors.EmptyDataError:
        logging.error("Archivo vacío.")
    except Exception as e:
        logging.error(f"Error al cargar el archivo: {str(e)}")
    return None

def remove_duplicates(df):
    """ Elimina duplicados en el DataFrame y retorna el DataFrame limpio. """
    initial_count = len(df)
    df.drop_duplicates(inplace=True)
    final_count = len(df)
    logging.info(f"Duplicados eliminados: {initial_count - final_count}")
    return df

def fill_missing_values(df):
    """ Rellena los valores faltantes con estrategias específicas para cada tipo de columna. """
    numerics = ['int16', 'int32', 'int64', 'float16', 'float32', 'float64']
    for column in df.columns:
        if df[column].dtype in numerics:
            df[column].fillna(df[column].median(), inplace=True)  # Uso de mediana para reducir el impacto de los valores atípicos
        else:
            df[column].fillna(df[column].mode()[0], inplace=True)  # Moda para datos categóricos
    logging.info("Valores faltantes rellenados.")
    return df

def correct_data_types(df):
    """ Corrige tipos de datos basándose en el nombre de la columna. """
    for column in df.columns:
        if 'date' in column.lower() or 'time' in column.lower():
            df[column] = pd.to_datetime(df[column], errors='coerce', infer_datetime_format=True)
        elif 'id' in column.lower() or 'code' in column.lower():
            df[column] = df[column].astype('category')
    logging.info("Tipos de datos corregidos.")
    return df

def clean_data(file_path):
    """ Función principal que orquesta la carga, limpieza y almacenamiento de los datos. """
    df = load_data(file_path)
    if df is not None:
        df = remove_duplicates(df)
        df = fill_missing_values(df)
        df = correct_data_types(df)
        cleaned_file_path = 'cleaned_data.csv'
        df.to_csv(cleaned_file_path, index=False)
        logging.info(f"Datos limpiados y guardados en {cleaned_file_path}.")
    else:
        logging.error("La limpieza de datos ha fallado debido a problemas en la carga de datos.")

if __name__ == "__main__":
    file_path = 'path_to_your_data.csv'  # Ajusta esto a la ruta de tu archivo de datos
    clean_data(file_path)
