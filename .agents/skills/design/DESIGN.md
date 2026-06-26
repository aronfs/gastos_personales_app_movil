# Sistema de Diseño: Tokens, Color y Tipografía

Base fintech moderna construida sobre **Material Design 3**, grid de **8px** y accesibilidad **AA**.

---

## 🎨 Paleta de Color

### Colores Semánticos y de Marca
* **PRIMARY:** `#2563EB` (Azul principal de marca)
* **SECONDARY:** `#14B8A6` (Verde azulado / Teal para elementos secundarios)
* **SUCCESS:** `#22C55E` (Verde para estados de éxito, confirmaciones y saldos positivos)
* **WARNING:** `#F59E0B` (Naranja / Ámbar para alertas, advertencias o estados pendientes)
* **ERROR:** `#EF4444` (Rojo para errores, cancelaciones y alertas críticas)

### Colores de Superficie y Fondo
* **BG Light:** `#FFFFFF` (Fondo claro principal)
* **Surface:** `#F8FAFC` (Superficies secundarias, tarjetas o contenedores)
* **BG Dark:** `#0F172A` (Fondo oscuro para componentes específicos o modo oscuro)

---

## 🔤 Tipografía (Familia tipográfica: `Inter`)

| Rol de UI | Ejemplo de Texto | Tamaño / Escala |
| :--- | :--- | :--- |
| **DISPLAY** | Aa 1234 | 32pt |
| **H1** | Balance total | 24pt |
| **H2** | Movimientos | 20pt |
| **BODY** | Texto corrido | 14pt |
| **CAPTION** | Etiqueta UI | 12pt |

---

## 📐 Spacing & Borders (Grid de 8px)

### Sistema de Espaciado (8px grid)
El sistema se basa en incrementos de 8px para mantener la consistencia visual y el ritmo vertical:
* **8px**
* **16px**
* **24px**
* **32px**
* **48px**

### Bordes (Border Radius)
* **sm:** Esquinas sutiles para componentes pequeños (botones pequeños, inputs).
* **md:** Radio intermedio para tarjetas secundarias o elementos medianos.
* **lg:** Radio pronunciado para contenedores principales.
* **xl:** Radio extra grande para secciones destacadas.
* **full:** Bordes completamente redondeados (píldoras, avatares, tags).

---

## ♿ Accesibilidad AA + Elevaciones

### Elevaciones (Material Design 3)
* **Level 0:** Elevación material plana (al ras de la superficie).
* **Level 1:** Elevación material leve con sombra sutil para separar elementos.
* **Level 2:** Elevación material moderada para destacar modales, menús o elementos interactivos flotantes.

### Criterios de Accesibilidad y Usabilidad
* **Contraste:** Cumplimiento estricto con el estándar **AA 4.5:1** para asegurar legibilidad.
* **Touch target:** Área de interacción mínima de **≥ 44px** para facilitar la pulsación en dispositivos móviles.
* **Focus visible:** Anillo de enfoque explícito de **Ring 2px** para navegación accesible por teclado.
* **Motion safe:** Respeto a las preferencias del sistema del usuario (**Reduce motion**) para evitar animaciones que causen malestar.