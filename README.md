# CryptoApp — Aplicación de Criptomonedas en Flutter

Aplicación móvil desarrollada en Flutter/Dart que permite consultar precios de criptomonedas en tiempo real, gestionar favoritos, llevar un portafolio personal y visualizar datos mediante gráficas.

---

## Descripción

CryptoApp es una aplicación enfocada en el mundo de las criptomonedas que integra:

- Datos en tiempo real desde una API pública  
- Sistema de favoritos  
- Gestión de portafolio personal  
- Gráficas de análisis  
- Interfaz moderna estilo trading  

---

## Funcionalidades principales

### Datos en tiempo real
- Lista de criptomonedas con:
  - Precio actual  
  - Variación en 24h  
  - Imagen/logo  
- Actualización con pull-to-refresh  
- Búsqueda en tiempo real  

### Detalle de criptomoneda
- Precio actual  
- Market cap  
- Volumen  
- Ranking global  
- Descripción  

### Favoritos
- Guardar criptomonedas  
- Eliminarlas fácilmente  
- Persistencia con SQLite  

### Portafolio
- Registro de compras  
- Cálculo automático de ganancias/pérdidas  
- Visualización de distribución  

### Gráficas
- Gráfica de precios históricos (línea)  
- Gráfica de portafolio (pie chart)  

---

## Arquitectura

El proyecto está organizado de forma modular:
lib/
├── services/ # API (CoinGecko)
├── providers/ # Manejo de estado (Riverpod)
├── screens/ # Pantallas principales
├── models/ # Modelos de datos
├── database/ # SQLite (favoritos y portafolio)
├── widgets/ # Componentes reutilizables

### Flujo de datos
API → Service → Provider → UI

---

## Tecnologías utilizadas

- Flutter / Dart  
- Riverpod  
- HTTP  
- SQLite (sqflite)  
- fl_chart  

---

## API utilizada

CoinGecko API  
https://www.coingecko.com/en/api

---

## Integrantes

- Pamela Barbosa (00335579)
- Estefania Solórzano (00332809)
- Joel Quijia (00331585)

---

## Instalación y ejecución

1. Clonar el repositorio:
git clone https://github.com/pamelabarbosacostales1965-ctrl/Cryptoapp.git
2. Entrar al proyecto:
cd Cryptoapp
3. Instalar dependencias:
flutter pub get
4. Ejecutar la aplicación:
flutter run

---

## Requisitos cumplidos

- Uso de API pública  
- Manejo de estados con Riverpod  
- Base de datos local (SQLite)  
- Uso de gráficas (fl_chart)  
- Diseño funcional y estructurado  

---